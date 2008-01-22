Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbYAVNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbYAVNLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYAVNL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:11:26 -0500
Received: from ext-ch1gw-9.online-age.net ([64.37.194.17]:33781 "EHLO
	ext-ch1gw-9.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYAVNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:11:24 -0500
X-Greylist: delayed 1697 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 08:11:22 EST
Date: Tue, 22 Jan 2008 13:42:55 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Newall <davidn@davidnewall.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122124255.GA22308@wszip-kinigka.euro.med.ge.com>
References: <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122111205.GA25090@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 080122, Ingo Molnar wrote:
> 
> * David Newall <davidn@davidnewall.com> wrote:
> 
> > Andi Kleen wrote:
> > > You seem to be under the illusion that iBCS2 support works currently
> > > in mainline and that only this patch would break it.
> >
> > I cannot imagine what brings you to that conclusion.  Suffice to say 
> > you are entirely and inexplicably wrong.
> 
> it should be very easy for you to prove me wrong then. I've got a very 
> simple question: please tell me, how do i run a binary compiled for an 
> iBCS2 platform under Linux v2.6.23?


at least the Changelog for ibcs-3.4.tar.gz found on

http://sourceforge.net/project/showfiles.php?group_id=13130

says:

2007-10-11  Alex <agon04@users.sourceforge.net>

        ibcs-3.4

        * support for Kernel 2.6.23 added
        * support for SUSE AppArmor


I did not try this one myself.

Karl

> 
> I've got plenty of v2.6.23-running testsystems, tell me, if i wanted, 
> how could i run any iBCS2 binary on them? All i see is a massive, 
> 2.4-kernels-only patchkit:
> 
>    http://www.kernel.org/pub/linux/kernel/people/hch/linux-abi/v2.4/
> 
> which external patch-kit was not picked up by major distros and which 
> was never integrated into the upstream kernel either. iBCS2 support in 
> Linux 2.6 simply does not exist.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Karl Kiniger            mailto:karl.kiniger@med.ge.com
GE Medical Systems Kretztechnik GmbH & Co OHG
Tiefenbach 15           Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
A-4871 Zipf Austria     Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
