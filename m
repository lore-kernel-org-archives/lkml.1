Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZKWQLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZKWQLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 11:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZKWQLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 11:11:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:43328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZKWQLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 11:11:07 -0500
Date: Mon, 23 Nov 2009 17:11:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] do not overwrite the first part of phys string
In-Reply-To: <20091123160841.GA3491@core.coreip.homeip.net>
Message-ID: <alpine.LSU.2.00.0911231710390.6953@wotan.suse.de>
References: <4B079CE0.60604@freemail.hu> <20091123160841.GA3491@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009, Dmitry Torokhov wrote:

> Do you want to split out usbkbd section or do you want me to pick up
> everything?

Please go ahead with everything.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

for that part, FWIW.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
