Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZIQLX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZIQLX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZIQLXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:23:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45174 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZIQLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:23:25 -0400
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
In-Reply-To: <20090917111828.GB7205@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <20090917100841.GF13002@csn.ul.ie>
	 <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie>
	 <1253186019.4975.32.camel@penberg-laptop> <20090917111828.GB7205@csn.ul.ie>
Date: Thu, 17 Sep 2009 14:23:27 +0300
Message-Id: <1253186607.4975.36.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Thu, 2009-09-17 at 12:18 +0100, Mel Gorman wrote:
> Please consider disabling it as an option in the rc3 stage or the like.
> With luck, I'll find a suitable machine in time and see what can be
> done. I just don't like the idea of x86 defaulting to one allocator and
> ppc defaulting to another.

SLQB is _not_ the default allocator in slqb/core and won't be one for
2.6.32 even if we do manage to sneak the allocator to linus.git.

			Pekka

