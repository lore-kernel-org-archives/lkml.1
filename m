Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743Ab0AKBgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0AKBgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069Ab0AKBgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:36:12 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:50722 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0AKBgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R4sfRmj+6r2lVncO89snXdYQmnH/zKM2V6D44JSJWEJsVCbY2AitQ2+emAdAKz3pz9
         Zdi9SSpZxXTXS6F6Yp5qlByJ1U0330/I/rQa8eJBreAP2auVCN/c1NiUz9Nw6R+sj8Ns
         1qPp8u3QHJIjPiZxJu7OCBp1TNM5jsgfA0wKw=
Date: Sun, 10 Jan 2010 19:36:06 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Michal Marek <mmarek@suse.cz>,
       Oliver Hartkopp <oliver@hartkopp.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Bug #14907] Commit "kbuild: fix bzImage build for x86" breaks
 build
Message-ID: <20100111013606.GA7031@progeny.tock>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
 <omZ8aBZReyD.A.lV.kNlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <omZ8aBZReyD.A.lV.kNlSLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14907
> Subject		: Commit "kbuild: fix bzImage build for x86" breaks build
> Submitter	: Oliver Hartkopp <oliver@hartkopp.net>
> Date		: 2009-12-19 19:21 (23 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4a2ff67c88211026afcbdbc190c13f705dae1b59
> References	: http://marc.info/?l=linux-kernel&m=126125050622195&w=4
> 		  http://marc.info/?l=linux-kernel&m=126114565103300&w=4
> 		  http://marc.info/?l=linux-kbuild&m=126202819526623&w=2
> Handled-By	: Jonathan Nieder <jrnieder@gmail.com>
> Patch		: http://thread.gmane.org/gmane.linux.kbuild.devel/4313/focus=4319
> 		  http://patchwork.kernel.org/patch/71957/

I am using the patch without problems, but it is not in the mainline
as of v2.6.33-rc3-git3.  So please do keep the bug listed.

Thanks,
Jonathan
