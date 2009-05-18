Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZERQfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZERQfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZERQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:35:07 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:63909 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZERQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:35:07 -0400
Message-ID: <4A118E36.40204@gawab.com>
Date: Mon, 18 May 2009 09:35:02 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>
Subject: Re: [Bug #13188] horizontal strips of the screen frozen
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.hMB._YzDKB@chimera>
In-Reply-To: <385Pu-agh7M.A.hMB._YzDKB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13188
> Subject		: horizontal strips of the screen frozen
> Submitter	: Justin Madru <jdm64@gawab.com>
> Date		: 2009-04-24 20:59 (23 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=280b713b5b0fd84cf2469098aee88acbb5de859c
> References	: http://marc.info/?l=linux-kernel&m=124060685315937&w=4
>
>
>
>   
As far as I can tell, this seams to be fixed by the intel-2.7.1 driver, 
and the bug only happened with UXA.
I did some minor testing and I couldn't trigger the bug. (earlier 
discussion in http://lkml.org/lkml/2009/4/23/587)
So this seams to be a user space bug, fixed in the intel-2.7.1 bug fix 
release (intel-2.7.0 still has the issue).

Justin Madru

