Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZKDN2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZKDN2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZKDN2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:28:32 -0500
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:47902 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753923AbZKDN2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:28:31 -0500
Date: Wed, 4 Nov 2009 08:27:02 -0500
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Horton <phorton@bitbox.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] prevent AoE causing cache aliases
Message-ID: <20091104132702.GA22112@ed-cashins-computer.local>
References: <20091022142228.GA18986@bitbox.co.uk> <20091103163755.57d3530c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103163755.57d3530c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 04:37:55PM -0800, Andrew Morton wrote:
> On Thu, 22 Oct 2009 15:22:28 +0100
> phorton@bitbox.co.uk (Peter Horton) wrote:
> 
> > To: ecashin@coraid.com
> 
> Have you heard back from Ed on this?

Sorry, I didn't comment because I don't have much experience
with virtually indexed caches, and while the fix seems to
make sense, I was hoping to learn more from the discussion
to follow.

I do think that it would be helpful to spell out "virtually
indexed" in the comment.  "VI" might not be enough to jog
the memory of folks who haven't used such an architecture
recently.

-- 
  Ed

