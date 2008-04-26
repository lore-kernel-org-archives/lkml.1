Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYDZLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYDZLoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYDZLo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:44:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYDZLo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:44:27 -0400
Date: Sat, 26 Apr 2008 08:43:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUILDFIX PATCH] v4l/dvb: add statics to avoid multiple
 definitions
Message-ID: <20080426084304.65688c60@gaivota>
In-Reply-To: <20080426100130.GA2252@cs181133002.pp.htv.fi>
References: <1209175388.14173.10.camel@brick>
	<20080426100130.GA2252@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008 13:01:30 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> I'm wondering what I am doing wrong since I already sent the same patch 
> and it went not into Linus' tree.

>From my side I needed to re-generate my local -git copy, since I have two hunks
from one patch moved to another patch (sigh!). 

Although all tests I did here pointed to a broken tree, likely caused by stgit,
I felt the need of reviewing my environment, before sending more patches to
mainstream, to avoid further issues. I've scheduled your patches with top
priority, but I didn't forwarded any patches yet.

I was intending to do this on this Sat, since I would have more time for the
checks I want to do.

Sorry for the inconvenience.

Cheers,
Mauro
