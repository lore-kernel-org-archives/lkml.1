Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYLAKc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYLAKc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYLAKcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:32:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:59126 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLAKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:32:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IOufY2qslVxZDCRuapZqOBt9CL6p6hz+cdtT5L3Ifl/0P7U8iqfU5Zlt6fFjZ0m8Ox
         X96uefB7SaYLvFuA42oETYLHUkAcGbq9ZZl91aL1HwyBCaxGVGPFsWbiSLg4TAIJomt9
         ey+RDep1L3wv9Nkk1RhyHjeZBryB946xuGQmU=
Message-ID: <aa79d98a0812010232s4a2f13f9v2a34c4368047d000@mail.gmail.com>
Date: Mon, 1 Dec 2008 13:32:15 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Avi Kivity" <avi@redhat.com>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, lguest@ozlabs.org,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Alexander van Heukelum" <heukelum@fastmail.fm>, jeremy@xensource.com,
       LKML <linux-kernel@vger.kernel.org>, "Mike Travis" <travis@sgi.com>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andi Kleen" <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <4933AD51.5000202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104150729.GC21470@localhost>
	 <20081129154516.GA26579@mailshack.com> <49318871.8010501@redhat.com>
	 <200812011502.37170.rusty@rustcorp.com.au>
	 <4933AD51.5000202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 12:24 PM, Avi Kivity <avi@redhat.com> wrote:
...
>
> Once it's done there's no reason not to commit it.  But the effort expended
> to do it is gone, without any measurable return.
>
>
...

Not sure Avi what you mean but as far as I know Alexander is working on
this file so he need just time to finish (we all have other duties you know :).
So I think the idea Peter proposed could be merged right after Alexander
will have finished. At least the Peter's suggestion was recorded in this
thread which means it will *not* be lost eventually. Or you meant something
else (yep, I could have it translated plain wrong)?
