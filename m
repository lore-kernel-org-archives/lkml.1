Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0BMXvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:51:40 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:42223 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab0BMXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:51:38 -0500
Date: Sun, 14 Feb 2010 10:51:36 +1100
From: Simon Horman <horms@verge.net.au>
To: Mohan Reddy <mohanreddykv@gmail.com>
Cc: wensong@linux-vs.org, linux-kernel@vger.kernel.org,
       lvs-devel@vger.kernel.org, ja@ssi.bg, kvmrdy@gmail.com
Subject: Re: SCTP Trasport Loadbalancing Support for IPVS
Message-ID: <20100213235136.GF16999@verge.net.au>
References: <20100212122301.GA4376@mohan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212122301.GA4376@mohan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 05:53:04PM +0530, Mohan Reddy wrote:
> Hi Simon&Wensong,
> 
> Please some review this code and let me know your comments. I am re-posting this
> as there is no response from any one. You are welcome for any type of comments.
> 
> This patch enhances IPVS to load balance SCTP transport protocol packets. This
> is done based on the SCTP rfc 4960. All possible control chunks have been 
> taken care. The state machine used in this code looks some what lengthy. I
> tried to make the state machine easy to understand. 
> 
> This patch is against nf-next.2.6 tree.

Hi Mohan,

sorry for not reviewing your earlier posting.
I've been insanely busy over the past few weeks.
I will try to make time in the next few days.

