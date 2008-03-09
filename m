Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbYCIOxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYCIOxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 10:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYCIOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 10:52:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:41002 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYCIOwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 10:52:53 -0400
Date: Sun, 9 Mar 2008 15:52:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ralf Baechle <ralf@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH] Input: fix cobalt_btns loadable keymap support
In-Reply-To: <20080309104323.GA24303@linux-mips.org>
Message-ID: <Pine.LNX.4.64.0803091552020.18589@twin.jikos.cz>
References: <20080309104323.GA24303@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Ralf Baechle wrote:

> This patch was submitted about two weeks ago by Yoichi but seems to have 
> been lost.  Without this patch the Cobalt defconfig won't build, so it's 
> 2.6.25 stuff.

Sorry, I completely missed this one when harvesting for rotting input 
patches.

Thanks,

-- 
Jiri Kosina
SUSE Labs

