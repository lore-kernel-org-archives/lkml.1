Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZKDRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZKDRZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZKDRZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:25:05 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:34300 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448AbZKDRZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:25:03 -0500
Date: Wed, 4 Nov 2009 18:25:07 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-14?B?TeVucyBSdWxs?= =?ISO-8859-14?B?Z+VyZA==?= 
	<mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
 <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>
 <alpine.OSX.1.10.0911011540400.53392@caridad.local>
 <20091102000147.424f104b@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911012023020.55434@caridad.local>
 <Pine.LNX.4.64.0911041710530.2927@artax.karlin.mff.cuni.cz>
 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Alan Cox wrote:

> > - With Linux package managers, the user is stuck with the software and 
> >   version shipped by the distribution. If he wants to install anything 
> >   newer or older, it turns into black magic and the typical desktop user 
> >   (non-hacker) can't do it.
> 
> In the rpm/yumworld that would be "yum downgrade" and "yum upgrade" for
> packages or whatever button on whatever gui wrapper you happen to have.

And what if there isn't a package? Upgrade option doesn't solve the need 
for [ distributions X software ] matrix of packages.

> And of course yum supports third party repositories so you can also deal
> with the updating problem which Windows tends not to do well for third
> party software.

A practical example --- when I wanted to get Wine on RHEL 5, all I found 
was a package for 1.0.1. Nothing newer.

I managed to compile the current version of Wine (it wasn't straghtforward 
and took few days to solve all the problems) and it ran the program I 
wanted. But I can imagine that a typical business user or home gamer will 
just say "that Linux sux".

You can say that I should delete RHEL-5 and install Fedora, but that is 
just that "upgrade one program" => "upgrade all programs" problem.

Mikulas
