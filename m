Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbYAIK2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbYAIK2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYAIK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:28:29 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:38237 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYAIK22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:28:28 -0500
Date: Wed, 9 Jan 2008 11:28:21 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080109102821.GA14085@citd.de>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <20080108230600.GA9071@citd.de> <20080109075658.GA29920@jolt.modeemi.cs.tut.fi> <20080109102139.GA14012@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109102139.GA14012@citd.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.01.2008 11:21, Matthias Schniedermeyer wrote:
> On 09.01.2008 09:56, Tuomo Valkonen wrote:
> > On 2008-01-09 00:06 +0100, Matthias Schniedermeyer wrote:
> > > That what LABEL und UUID-Support in mount is for.
> > 
> > That's udev shit. I don't want it.
> 
> No.

To be more verbose.

The 'LABEL=' is native mount turf and is much older than udev.

That udev ALSO supports the same labels, by providing sym-links in 
/dev/disk/by-label/<...>, is written on another page.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

