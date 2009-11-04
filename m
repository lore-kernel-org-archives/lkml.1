Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbZKDUH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbZKDUH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZKDUH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:07:56 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:51369 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbZKDUH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:07:56 -0500
Date: Wed, 4 Nov 2009 21:08:01 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Valdis.Kletnieks@vt.edu
cc: Martin Nybo Andersen <tweek@tweek.dk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <22108.1257364949@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
 <200911041848.48721.tweek@tweek.dk>           
 <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
 <22108.1257364949@turing-police.cc.vt.edu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Valdis.Kletnieks@vt.edu wrote:

> On Wed, 04 Nov 2009 19:46:44 +0100, Mikulas Patocka said:
> 
> > When I did it (from Etch to Lenny), two programs that I have compiled 
> > manually ("vim" and "links") stopped working because Etch and Lenny have 
> > binary-incompatible libgpm.
> > 
> > If some library cannot keep binary compatibility, it should be linked 
> > staticaly, dynamic version shouldn't even exists on the system --- so that 
> > no one can create incompatible binaries.
> 
> No, all they need to do is bump the .so version number.

That's what Debian did. Obviously, I can extract the old library from the 
old package. But non-technical desktop user can't.

Mikulas
