Return-Path: <linux-kernel-owner+w=401wt.eu-S1751229AbXA2Ls4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbXA2Ls4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXA2Lsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:48:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:38539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXA2Lsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:48:55 -0500
Date: Mon, 29 Jan 2007 09:24:30 +0100
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070129082430.GA6101@suse.de>
References: <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz> <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz> <878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070127174525.GA4787@ucw.cz>
X-Operating-System: openSUSE 10.2 (i586), Kernel 2.6.18.2-34-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 05:45:25PM +0000, Pavel Machek wrote:
> > This patch exports to the user space the inactivity time (in msecs) of a given
> > input device. Example follows:
> 
> Looks okay to me. I guess you should sign it off, and ask Dmitry
> (input maintainer) for a merge?

Hey, come on, "no new proc files", please ;-)

> > <0> $ cat /proc/bus/input/activity
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 
