Return-Path: <linux-kernel-owner+w=401wt.eu-S1161181AbXAZTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181AbXAZTKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161191AbXAZTKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:10:48 -0500
Received: from tcsfw4.tcs-sec.com ([65.127.223.133]:4889 "EHLO
	tcsfw4.tcs-sec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161181AbXAZTKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:10:47 -0500
Reply-To: <vyekkirala@trustedcs.com>
From: "Venkat Yekkirala" <vyekkirala@trustedcs.com>
To: "'Michal Piotrowski'" <michal.k.k.piotrowski@gmail.com>,
       "Adrian Bunk" <bunk@stusta.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: RE: 2.6.20-rc6: known unfixed regressions (part 2)
Date: Fri, 26 Jan 2007 13:08:58 -0600
Message-ID: <002f01c7417d$6f67cea0$cc0a010a@tcssec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2911.0)
Importance: Normal
In-Reply-To: <45BA50B7.1070205@googlemail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1441
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FYI- The patch can be viewed here:

http://marc.theaimsgroup.com/?l=linux-netdev&m=116983297300536&w=2

> -----Original Message-----
> From: Michal Piotrowski [mailto:michal.k.k.piotrowski@gmail.com]
> Sent: Friday, January 26, 2007 1:04 PM
> To: Adrian Bunk
> Cc: Linus Torvalds; Andrew Morton; Linux Kernel Mailing List; 
> Uwe Bugla;
> B.Zolnierkiewicz@elka.pw.edu.pl; linux-ide@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; Gerhard Dirschl; Christoph Hellwig;
> petero2@telia.com; Michal Piotrowski; Venkat Yekkirala; David Miller;
> sds@tycho.nsa.gov; jmorris@namei.org; netdev@vger.kernel.org; Livio
> Soares; Paul Mackerras; linuxppc-dev@ozlabs.org; Cijoml Cijomlovic
> Cijomlov; Nick Piggin; ttb@tentacle.dhs.org; rml@novell.com; Malte
> Schröder; Vladimir V. Saveliev; reiserfs-dev@namesys.com; Sami Farin;
> David Chinner; xfs-masters@oss.sgi.com
> Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
> 
> 
> Hi,
> 
> Adrian Bunk napisał(a):
> > This email lists some known regressions in 2.6.20-rc6 
> compared to 2.6.19
> > that are not yet fixed in Linus' tree.
> > 
> > If you find your name in the Cc header, you are either 
> submitter of one
> > of the bugs, maintainer of an affectected subsystem or 
> driver, a patch
> > of you caused a breakage or I'm considering you in any 
> other way possibly
> > involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc 
> when answering.
> > 
> > 
> > Subject    : SELinux compile error with CONFIG_XFRM=n
> > References : http://lkml.org/lkml/2007/1/25/233
> > Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> > Caused-By  : Venkat Yekkirala <vyekkirala@TrustedCS.com>
> >              commit 334c85569b8adeaa820c0f2fab3c8f0a9dc8b92e
> > Handled-By : Venkat Yekkirala <vyekkirala@TrustedCS.com>
> >              David Miller <davem@davemloft.net>
> > Status     : problem is being discussed
> > 
> 
> Venkat Yekkirala has sent me a patch that fixed this build problem.
> 
> Thanks!
> 
> Regards,
> Michal
> 
> -- 
> Michal K. K. Piotrowski
> LTG - Linux Testers Group
> (http://www.stardust.webpages.pl/ltg/)
> 

