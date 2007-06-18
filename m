Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbXFRXSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbXFRXSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762944AbXFRXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:18:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58900 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754992AbXFRXSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:18:33 -0400
Date: Mon, 18 Jun 2007 16:18:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Thomas Glanzmann <thomas@glanzmann.de>
cc: carlo@alinoe.com, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
       GIT <git@vger.kernel.org>
Subject: Re: GIT Packages for Debian Etch
In-Reply-To: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.64.0706181617060.18601@schroedinger.engr.sgi.com>
References: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Thomas Glanzmann wrote:

> Hello,
> a friend of mine always builds the Debian Packages from unstable for
> Debian Etch. I have on all my machines the following line in
> /etc/apt/sources.list:
> 
>         deb http://rmdir.de/~michael/git/ ./
> 
> apt-get update; apt-get dist-upgrade
> 
> and you're up2speed.
> 
> If you don't trust that packages it is very easy to build them yourself:

Is there some way you can feed that into Debian please? Why the go around 
through a separate repository? The maintainer of git-core is not actively 
maintaining the package?

