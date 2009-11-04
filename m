Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZKDWFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZKDWFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbZKDWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:05:13 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:56883 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267AbZKDWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:05:12 -0500
Date: Wed, 4 Nov 2009 23:05:17 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: kevin granade <kevin.granade@gmail.com>
cc: Valdis.Kletnieks@vt.edu, Martin Nybo Andersen <tweek@tweek.dk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> 
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk> 
 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz> 
 <200911041848.48721.tweek@tweek.dk>  <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
  <22108.1257364949@turing-police.cc.vt.edu> 
 <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz> 
 <23950.1257367315@turing-police.cc.vt.edu>  <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
 <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the important question here is what is is exactly that the
> package manager *did* to break the app you are talking about?

It interferred with my will to install the version of the software that I 
want.

> be, and not magically be able to discern that you've replaced one of
> the most core packages in the system (which, by the way is most
> definitely not something that %99.999 of users are going to try)

If you need new 3D driver because of better gaming performance ... if you 
need new lame because it encodes mp3 better ... if you need new libsane 
because it supports the new scanner that you have ... you are going to 
face the same problems like me when I needed new binutils. But the big 
problem is that persons needing these things usually don't have enough 
skills to install the software on their own and then fight with the 
package management system.

On Windows, the user can just download the EXE, run it, click 
next-next-next-finish and have it installed. There is no package 
management that would try to overwrite what you have just installed.

Mikulas
