Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZALLOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZALLOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZALLOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:14:05 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:56950 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbZALLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:14:04 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090112213339.feefdd02.sfr@canb.auug.org.au>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
	 <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	 <20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	 <20090112213339.feefdd02.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 12 Jan 2009 11:13:13 +0000
Message-Id: <1231758793.10982.13.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2009 11:13:14.0389 (UTC) FILETIME=[C3211C50:01C974A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 21:33 +1100, Stephen Rothwell wrote:
> On Mon, 12 Jan 2009 02:21:38 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > The many trees in linux-next are actually based on current mainline. 
> > So if you can prepare and maintain a tree based on current mainline,
> > Stephen could integrate that into linux-next, hopefully.
> 
> That's what I'm here for :-)

OK. I'll update the branch to 2.6.29-rc1 later today and let you know
(I'll also check for any obvious conflicts with linux-next).

Thanks.

-- 
Catalin

