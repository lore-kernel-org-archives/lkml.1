Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYBORxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYBORxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYBORxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:53:36 -0500
Received: from waste.org ([66.93.16.53]:34815 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbYBORxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:53:35 -0500
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux
	Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Sam Ravnborg <sam@ravnborg.org>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080215180456.GA517@one.firstfloor.org>
References: <20080212110825.35db27cb@crazy>
	 <20080212130428.GA32757@uranus.ravnborg.org>
	 <20080212150013.57cb954e@crazy>
	 <1202832132.12383.93.camel@cinder.waste.org>
	 <p73tzkazaxh.fsf@bingen.suse.de>
	 <1203094937.12383.212.camel@cinder.waste.org>
	 <20080215180456.GA517@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 11:52:53 -0600
Message-Id: <1203097973.12383.220.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 19:04 +0100, Andi Kleen wrote:
> > do when it does". There's very little point in having this sort of code
> > in a mass-market camera, phone, DVR, TV, etc. (of which there are
> 
> Do any of them run with a x86 CPU?

Yes. The last PVR I worked on was just such a device, as was the very
first device I put Linux on (1.2 era). There are several families of x86
CPUs targeted at embedded so this shouldn't be a surprise.

-- 
Mathematics is the supreme nostalgia of our time.

