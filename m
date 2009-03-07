Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZCGQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZCGQbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZCGQbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:31:17 -0500
Received: from fed1rmmtai113.cox.net ([68.230.241.47]:59748 "EHLO
	fed1rmmtai113.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZCGQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:31:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=rDF_XFhH7-gA:10 a=DiAPenQi9D4A:10
 a=Qh8hcu3gxmflD5jBwd0A:9 a=DVyTRcnWjK25bguQd93Ohri_cJUA:4 a=SKpDKCWXRSQA:10
X-CM-Score: 0.00
From: Chris Brannon <cmbrannon@cox.net>
To: Greg KH <greg@kroah.com>
cc: "J.R. Mauro" <jrm8005@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
In-reply-to: <20090307055404.GA549@kroah.com>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net> <20090306175708.GD3099@kroah.com> <3aaafc130903062143g4b7d6afel575781208319454e@mail.gmail.com> <20090307055404.GA549@kroah.com>
Date: Sat, 07 Mar 2009 10:08:53 -0600
Message-Id: <20090307160915.BLXJ27308.fed1rmmtao101.cox.net@fed1rmimpo01.cox.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Mar 07, 2009 at 12:43:43AM -0500, J.R. Mauro wrote:
> > That might be a good idea, assuming it doesn't start up a flamewar.
> 
> I don't think if we keep it all in one place, it would.
> 
> > The Glendix folks are working hard to get a lot of these device files
> > and filesystems implemented and it would be nice to see them have a
> > place to feel welcome.
> > Would it be very involved to get a little sandbox for these things?
> 
> drivers/plan9 looks like a nice place to me, any objections?

Treating all of the Plan 9 devices as a group seems good,
especially if it applies to Kconfig.
During the config process, one could easily ignore the whole group.

-- Chris
