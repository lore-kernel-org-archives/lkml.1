Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZLOGqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZLOGqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZLOGqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:46:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:46786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZLOGqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:46:06 -0500
Message-ID: <4B273108.9050301@kernel.org>
Date: Tue, 15 Dec 2009 15:47:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and cleanup
References: <20091214220320.665065925@quilx.com> <1260859066.4770.0.camel@penberg-laptop>
In-Reply-To: <1260859066.4770.0.camel@penberg-laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 03:37 PM, Pekka Enberg wrote:
> On Mon, 2009-12-14 at 16:03 -0600, Christoph Lameter wrote:
>> Leftovers from the earlier patchset. Mostly applications of per cpu counters
>> to core components.
> 
> I can pick up the SLUB patches. Is that OK with you Tejun?

Yeap, now that this_cpu stuff is upstream, no reason to route them
through percpu tree.  I'll be happy to pick up whatever is left.

Thanks.

-- 
tejun
