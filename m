Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXCECbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXCECbw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXCECbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:31:52 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:29514 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXCECbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:31:51 -0500
Date: Sun, 04 Mar 2007 18:31:40 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <200703040911.16845.gene.heskett@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>
Message-id: <Pine.LNX.4.64.0703041831010.1190@montezuma.windriver.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200703041800.53360.kernel@kolivas.org>
 <200703040825.42047.gene.heskett@gmail.com>
 <200703050049.50149.kernel@kolivas.org>
 <200703040911.16845.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2007, Gene Heskett wrote:

> >There will be times when the mainline scheduler feels more interactive
> > than this scheduler, and that is because it has significant unfairness
> > granted towards interactive tasks. This degree of unfairness in an
> > effort to maintain interactivity has been criticised and causes
> > problems in certain environments with both loss of fairness, relative
> > starvation and is not entirely predictable.
> 
> Well, in 20 minutes of playing, I am so far VERY impressed, the kmail 
> composer is typing to the screen in unison to my keystrokes, where with 
> the older version it often went away for 10 or more seconds at a time, 
> then displayed the last sentence I had typed in one (or 2 sometimes) 
> swell foop.  Now I can back up and correct a typo in real time whereas 
> before, it was often faster if the typo was half a line back, and the key 
> repeat so darned slow it was often over a second per character cell 
> moved, to go grab the mouse, position the cursor on the typo, click, wait 
> for the indicator to move, and then fix it.  Typing is now pleasurable 
> again.  Key repeats seem to remain at the set in the bios key repeat 
> speed.  Amazing.  I do believe you have given me back my machine.

What are the specs on your hardware?

