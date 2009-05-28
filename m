Return-Path: <linux-kernel-owner+w=401wt.eu-S1763768AbZE1SVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763768AbZE1SVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZE1SU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:20:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39813 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538AbZE1SU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:20:56 -0400
Date: Thu, 28 May 2009 19:20:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090528182008.GJ20736@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526153654.GA17096@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> The rest looks good.

Good, I've reverted the removal of "memory", and so I guess we're all
happy with the patch now.
