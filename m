Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYDGUva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYDGUva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYDGUvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:51:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:38155 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752147AbYDGUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:51:21 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18k+zlaXZ4kj88ehx4e9gr6Vm7aLp1vMiv87aa8QL
	cvtY2s1HvmwfsZ
Date: Mon, 7 Apr 2008 22:51:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kernel traczilla: tracking active kernel development
In-Reply-To: <Pine.LNX.4.64.0803171613310.4997@axis700.grange>
Message-ID: <Pine.LNX.4.64.0804072235470.8933@axis700.grange>
References: <Pine.LNX.4.64.0803171613310.4997@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Guennadi Liakhovetski wrote:

> The first thing one normally does before starting a new development is 
> research whether and what has already been done in this area. Unless, of 
> course, one knows it beforehand:-)
> 
> This research might sometimes be quite time-consuming and might not always 
> deliver expected results. Wouldn't it be good to have a central page for 
> tracking such hot kernel projects _before_ they get submitted into 
> mainline. One would just decide "now I am prepared to tell the world about 
> my work", go to this site, register, enter a description of his project in 
> an appropriate section with some contact information (a mailing list that 
> the developer is regularly reading should be enough). The site could be 
> just organized in a hierarchial manner. For example, to add a new ARM 
> XScale port one would go
> 
> top -> Processor architectures -> ARM -> XScale -> ...
> 
> I am no designer, no web-administrator, and no content-provider, but 
> knowing that LKML loves action above words, I put up a sceleton trac wiki 
> site at
> 
> http://gross-embedded.homelinux.org/trac.fcgi
> 
> so everybody could have a look, play with it, and decide if they think 
> something like this could be useful. This is not intended as a final 
> solution, so, don't take it too seriously. It is hosted on a 500MHz ARM 
> system, so, be patient:-)

Ok, in about 3 weeks there have been maybe 100 or 200 connections to the 
server, most of them from google and yahoo bots and from other less 
pleasant scanners:-) And - not a single new entry. I've modified the 
layout a bit to exactly reproduce the kernel tree, so on the top level I 
have arch/, block/, drivers/, net/, etc. So it should even be easier to 
find a suitable place to enter ones work and to find previous 
developments. I'll leave this site for another 2-3 days running, but if 
it still doesn't attract any contributors and / or feadback, I'll just 
take it down.

I certainly can understand why there wasn't much interest in it. If a 
development is payed, one often is not allowed to disclose it before the 
completion. I've hoped that "free" developers might get attracted by this 
idea, but this seems to be not the case either, or just not many of them 
read LKML:-)

Anyway, this is just to document the intention to close the page.

Thanks
Guennadi
---
Guennadi Liakhovetski
