Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZHTElH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZHTElH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 00:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZHTElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 00:41:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51995 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZHTElG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 00:41:06 -0400
Date: Wed, 19 Aug 2009 21:40:59 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, bblum@andrew.cmu.edu,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Revert commit
	8827c288feb7810185aa7c2e37537202fc709869
Message-ID: <20090820044059.GE29801@count0.beaverton.ibm.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com> <4A8CB62F.8030504@cn.fujitsu.com> <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com> <4A8CBEDC.6010709@cn.fujitsu.com> <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 08:13:59PM -0700, Paul Menage wrote:
> On Wed, Aug 19, 2009 at 8:11 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> >
> > As you said, the 2 patches differ just in using different var/func
> > names, so rebasing shouldn't be hard but maybe a bit boring.
> >
> 
> Yes - it's a fair amount of work for no real gain.

So this revert won't introduce a regression for any potential tests?

Cheers,
	-Matt Helsley
