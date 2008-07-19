Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYGSJgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYGSJgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYGSJg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:36:28 -0400
Received: from 8bytes.org ([88.198.83.132]:41659 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYGSJg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:36:28 -0400
Date: Sat, 19 Jul 2008 11:36:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce x86_ops
Message-ID: <20080719093627.GC31439@8bytes.org>
References: <200807190207.26077.yhlu.kernel@gmail.com> <20080719091612.GB13662@8bytes.org> <86802c440807190219m4cd71274qaea4975a9add15d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807190219m4cd71274qaea4975a9add15d4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 02:19:57AM -0700, Yinghai Lu wrote:
> On Sat, Jul 19, 2008 at 2:16 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > Hi Yinghai,
> >
> > can you please write a short commit message explaining the benefit? Also
> > x86_ops sounds a bit too generic for some architecture specific
> > initialization function pointers imho.
> 
> put all over visws_quirks in one structs, and may extend that to othat subarch

Ok, then the struct should have 'quirks' in its name maybe :)

Joerg

