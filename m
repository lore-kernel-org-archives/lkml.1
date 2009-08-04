Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbZHDXFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbZHDXFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933437AbZHDXFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:05:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933363AbZHDXFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:05:03 -0400
Date: Tue, 4 Aug 2009 16:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: sam@ravnborg.org, hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       albin.tonnerre@free-electrons.com
Subject: Re: [PATCH 3/6] Add support for LZO-compressed kernels
Message-Id: <20090804160420.1e911623.akpm@linux-foundation.org>
In-Reply-To: <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com>
References: <20090731093107.GA29704@merkur.ravnborg.org>
	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
	<1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com>
	<1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Aug 2009 16:58:18 +0200
Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> This is the first part of the lzo patch

Please pass this patch (and all others!) through scritps/checkpatch.pl.

checkpatch reports a number of trivial errors which you wouldn't have included
had you known about them.
