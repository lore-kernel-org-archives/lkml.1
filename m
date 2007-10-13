Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbXJMA6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbXJMA6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbXJMA6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:58:16 -0400
Received: from www.tglx.de ([62.245.132.106]:60572 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbXJMA6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:58:16 -0400
Date: Sat, 13 Oct 2007 02:58:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Correct filenames in comments.
In-Reply-To: <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0710130257280.3918@localhost.localdomain>
References: <20071013004332.GA18760@redhat.com> <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Oct 2007, Andrew Morton wrote:

> On Fri, 12 Oct 2007 20:43:32 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > I never really understood the motivation behind putting the filename
> > in a comment, but this fixes up a bunch of them that are now wrong
> > post-merge.
> 
> Let's just delete them.
> 

ACk
	tglx

