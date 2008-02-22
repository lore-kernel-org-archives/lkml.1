Return-Path: <linux-kernel-owner+w=401wt.eu-S1764364AbYBVTLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764364AbYBVTLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbYBVTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:11:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:64217 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYBVTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:11:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Iitzne7/JVD/3n/PSielvGVBKdvb2DfAyOyVGjt4Lr9Cwf2mAb2OOKG/b4CZH5Gw7RV9vPBrxPGt3LK7zdPQ5AxGBcuyn4wMFZvSgpyB+hlK14dCaCJSYMyds3EgeFFFMmNwlRv+QXlMhJjN7kbSQJu+A6bpMaZyQyfznfGcgYk=
Message-ID: <e2e108260802221111x25c7b762i2326058fc49d6338@mail.gmail.com>
Date: Fri, 22 Feb 2008 20:11:09 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ofa-general] Re: Merging of completely unreviewed drivers
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Glenn Streiff" <gstreiff@neteffect.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Faisal Latif" <flatif@neteffect.com>
In-Reply-To: <20080222185359.GA29945@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	 <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	 <20080221154951.GA28328@cs181133002.pp.htv.fi>
	 <adahcg2awag.fsf@cisco.com>
	 <20080221210124.GD28328@cs181133002.pp.htv.fi>
	 <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	 <20080222185359.GA29945@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 7:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
>     If a patch or if a file has a clean _style_, bugs and deeper
>     structural problems often stand out like a sore thumb. But if the
>     code is peppered with random style noise, it's a lot harder (for me
>     at least) to notice real bugs. I can notice bugs in a squeeky clean
>     code base about 5 times easier than in a noisy codebase. This effect
>     alone makes checkpatch indispensible for the scheduler and for
>     arch/x86.

I also appreciate style uniformity in kernel code. My (limited)
experience with checkpatch is that most checkpatch complaints are easy
to resolve.

Bart Van Assche.
