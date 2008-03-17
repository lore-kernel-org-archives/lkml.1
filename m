Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYCQP37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYCQP37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYCQP3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:29:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:34443 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751339AbYCQP3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:29:51 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18vM2tn8OYv886i+vnyNTmBnjvLCwfP0PW+9pJt1A
	5ZY7LaeJ1l7dYw
Date: Mon, 17 Mar 2008 16:30:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC] kernel traczilla: tracking active kernel development
Message-ID: <Pine.LNX.4.64.0803171613310.4997@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The first thing one normally does before starting a new development is 
research whether and what has already been done in this area. Unless, of 
course, one knows it beforehand:-)

This research might sometimes be quite time-consuming and might not always 
deliver expected results. Wouldn't it be good to have a central page for 
tracking such hot kernel projects _before_ they get submitted into 
mainline. One would just decide "now I am prepared to tell the world about 
my work", go to this site, register, enter a description of his project in 
an appropriate section with some contact information (a mailing list that 
the developer is regularly reading should be enough). The site could be 
just organized in a hierarchial manner. For example, to add a new ARM 
XScale port one would go

top -> Processor architectures -> ARM -> XScale -> ...

I am no designer, no web-administrator, and no content-provider, but 
knowing that LKML loves action above words, I put up a sceleton trac wiki 
site at

http://gross-embedded.homelinux.org/trac.fcgi

so everybody could have a look, play with it, and decide if they think 
something like this could be useful. This is not intended as a final 
solution, so, don't take it too seriously. It is hosted on a 500MHz ARM 
system, so, be patient:-)

Any opinions, comments, suggestions are welcome.

Thanks
Guennadi
---
Guennadi Liakhovetski
