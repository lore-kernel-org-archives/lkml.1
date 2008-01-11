Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbYAKOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbYAKOk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYAKOkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:40:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60827 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753712AbYAKOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:40:15 -0500
Message-ID: <47877FCA.8050707@sgi.com>
Date: Fri, 11 Jan 2008 15:40:10 +0100
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Cliff Wickman <cpw@sgi.com>, airlied@linux.ie, benh@kernel.crashing.org,
       michael@ellerman.id.au, jk@ozlabs.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [rfc][patch] reimplement nopfn callers with fault
References: <20080108113221.GA460@wotan.suse.de>
In-Reply-To: <20080108113221.GA460@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hi guys,
> 
> I'd like to finally remove nopfn from the tree. So I would really like to get
> this patch into -mm soon (or broken out patches into appropriate trees).
> 
> Anyway, I don't have a good way to compile mspec or cell changes very easily.
> Hopefully if there are any silly typos, they will be easier to fix. More problematic
> is actually testing the things; I'm not even sure I'm covering all bases with
> drm testing.
> 
> So, if I could trouble you for a quick review and/or test at some time.... the
> patch is against latest -mm.

Nick,

Is this supposed to apply to the latest Linus tree? I applied it here
and the mspec driver lights up in beautiful fireworks :-( I'll give the
-mm tree a try next.

Cheers,
Jes
