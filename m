Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZKDTpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZKDTpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbZKDTpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:45:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38682 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758021AbZKDTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:45:09 -0500
Date: Wed, 4 Nov 2009 19:46:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Martin Nybo Andersen <tweek@tweek.dk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-14?B?TeVucyBSdWxsZ+VyZA==?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
Message-ID: <20091104194606.032cb2f6@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	<20091104165407.1481bc29@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
	<200911041848.48721.tweek@tweek.dk>
	<Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > BTW: Wine has, like many others, the newest version of their software 
> > prepackaged for RHEL 4 & 5 among others at their site: 
> > http://www.winehq.org/download/
> 
> This is exactly the link that I followed and the last version for "RHEL 5" 
> is "wine-1.0.1-1.el5.i386.rpm".

So you have a supplier issue. A random windows user wouldnt cope with
that either. You try installing a Windows Vista only app on XP ;)

> A distribution that claims compatibility with the standard must ship 
> libraries that are compatible with the libraries in the standard (not 
> necessarily the same version, it may ship higher version for security or 
> so).

Welcome to the Linux Standard Base. It's been done and it exists.
Generally speaking open source projects don't seem to care to build to it
but prefer to build to each distro.
