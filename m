Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZLOEEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZLOEEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbZLOEEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:04:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:49095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZLOEEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:04:00 -0500
Message-ID: <4B270AE8.7090009@kernel.org>
Date: Tue, 15 Dec 2009 13:04:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 8/8] Remove cpu_local_xx macros
References: <20091214220320.665065925@quilx.com> <20091214220343.014956635@quilx.com>
In-Reply-To: <20091214220343.014956635@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2009 07:03 AM, Christoph Lameter wrote:
> These macros have not been used for awhile now and are not used
> by the last local_t user in the tree (trace ringbuffer logic).
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Cool.  Other than the things I commented before, the series looks
great to me.

Thanks for doing this.

-- 
tejun
