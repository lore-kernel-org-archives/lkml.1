Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbZKDRzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbZKDRzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZKDRzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:55:18 -0500
Received: from mail1-hoer.fullrate.dk ([90.185.1.42]:57403 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455AbZKDRzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:55:17 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 12:55:16 EST
From: Martin Nybo Andersen <tweek@tweek.dk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: package managers [was: FatELF patches...]
Date: Wed, 4 Nov 2009 18:48:48 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <20091104165407.1481bc29@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041848.48721.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009 18:25:07 Mikulas Patocka wrote:
> On Wed, 4 Nov 2009, Alan Cox wrote:
> > > - With Linux package managers, the user is stuck with the software and
> > >   version shipped by the distribution. If he wants to install anything
> > >   newer or older, it turns into black magic and the typical desktop
> > > user (non-hacker) can't do it.
> >
> > In the rpm/yumworld that would be "yum downgrade" and "yum upgrade" for
> > packages or whatever button on whatever gui wrapper you happen to have.
> 
> And what if there isn't a package? Upgrade option doesn't solve the need
> for [ distributions X software ] matrix of packages.
> 
> > And of course yum supports third party repositories so you can also deal
> > with the updating problem which Windows tends not to do well for third
> > party software.
> 
> A practical example --- when I wanted to get Wine on RHEL 5, all I found
> was a package for 1.0.1. Nothing newer.
> 
> I managed to compile the current version of Wine (it wasn't straghtforward
> and took few days to solve all the problems) and it ran the program I
> wanted. But I can imagine that a typical business user or home gamer will
> just say "that Linux sux".
> 
> You can say that I should delete RHEL-5 and install Fedora, but that is
> just that "upgrade one program" => "upgrade all programs" problem.

Have you ever tried upgrading Windows because some program is incompatible 
with the current installation? ... That is indeed an 'upgrade all' procedure 
... _If_ you're lucky enough to be able to reinstall your software.

Being able to upgrade at least Debian -- and others as well -- without the 
need to attend the computer is IMHO one of Linux' biggest wins.

BTW: Wine has, like many others, the newest version of their software 
prepackaged for RHEL 4 & 5 among others at their site: 
http://www.winehq.org/download/

If all else fail the developers could go for statically compiled binaries in 
an executable tarball, which then handles the installation to /usr/local

-Martin

