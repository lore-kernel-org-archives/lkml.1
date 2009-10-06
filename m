Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZJFHnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZJFHnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZJFHnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:43:04 -0400
Received: from smtp121.rog.mail.re2.yahoo.com ([206.190.53.26]:27224 "HELO
	smtp121.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755209AbZJFHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:43:03 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 03:43:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Fpb4tFkQbJ+Vf/O8mP6AuFN41/QJRy/lgl563nMWwueFiwsHPNEymtEPPAZucPoF71/Jbk+ND3N41CNLcKuj9IQIdtq4qK/Otqw/qEevzfi0VRy6lYQs/sVJBfcyetzKoUXPb78VViP8da+G0rIi15oYxEquTf2uYLB/tkaTvLo=  ;
X-YMail-OSG: lsb0Cm0VM1mOxz96iFo0lJnkQRiXF_weI8jAo1UOcDvEDU.55jL6CpZoFOm.yVTkWA--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
Date: Tue, 6 Oct 2009 03:35:02 -0400
User-Agent: KMail/1.12.90 (Linux/2.6.31.1-custom; KDE/4.3.69; x86_64; svn-1027797; 2009-09-23)
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de> <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de> <188185.1254800635@turing-police.cc.vt.edu>
In-Reply-To: <188185.1254800635@turing-police.cc.vt.edu>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910060335.02770.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 2, 2009 10:46:49 am Jeff Garzik wrote:
>Can you post full dmesg output?  And you have verified that vanilla 
>2.6.30 kernel works OK?
>
>        Jeff

I have not tried stock .30 kernel, I did try .32-rc2 vanilla and still no go. 
I can test .30 however this week. 

On October 5, 2009 11:43:55 pm Valdis.Kletnieks@vt.edu wrote:
> On Tue, 06 Oct 2009 00:15:48 +0200, Joerg Schilling said:
...
> 
> > You can help: Ask your Linux distributor why he distributes an illegal
> > and buggy fork instead of the legal original software!
> 
> Apparently it's distributed because their legal team doesn't think it's an
> illegal fork, and it's still buggy because after you relicensed to CDDL,
>  they felt they couldn't backport your fixes to the original GPL code.
> 

Listen, I don't care about that who forked what. if wodim or cdrecord is 
broken in design, then it's time for a cdrecord-ng and start over please.  I 
don't want to see this bickering anymore.

We're just damaging users. We really should not be rehashing CD/DVD burning 
issues over again when there's much, much more pressing issues that need to be 
fixed.

Joerg, For one thing, I want to be able to access the burner devices with 
their proper /dev name. Just like any other sane unix tool like, even dd. (you 
used to resist this idea if I remember correctly on MLs) not the SCSI bus IDs, 
honestly, what are you trying to achieve here?? make it EASY for users, not 
harder.

Also, maybe if you cooperated a little better we can clean up this stinking 
pile of mess. 

Sincerely,  
Shawn.
