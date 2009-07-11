Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZGKX4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZGKX4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 19:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZGKX4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 19:56:46 -0400
Received: from fifo99.com ([67.223.236.141]:52190 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZGKX4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 19:56:46 -0400
Subject: Re: HTC Dream: qdsp support for staging
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: greg@kroah.com, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090711230509.GA4705@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz>
	 <1247246757.7146.33.camel@desktop>  <20090711230509.GA4705@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 16:56:44 -0700
Message-Id: <1247356604.5967.6.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 01:05 +0200, Pavel Machek wrote:
> On Fri 2009-07-10 10:25:57, Daniel Walker wrote:
> > On Fri, 2009-07-10 at 10:37 +0200, Pavel Machek wrote:
> > > From: Iliyan Malchev <ibm@android.com>
> > > 
> > > QDSP code is neccessarry for communication with some hardware
> > > components on HTC Dream, including camera hardware. It also drives DSP
> > > coproccessor.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > You don't want to break it up into multiple patches? I'll do it if you
> > don't want too ..
> 
> I don't know how much sense it makes to split it further... yes, I
> could probably split it per file or something but...
> 
> (Notice that this is going to be rewriten in staging, anyway, before
> merging into kernel proper...)

Your expecting a full re-write? From a quick look this stuff just looks
like it needs some TLC ..

Daniel

