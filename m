Return-Path: <linux-kernel-owner+w=401wt.eu-S1763192AbZBYWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763192AbZBYWTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760513AbZBYWTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:19:40 -0500
Received: from ns1.coraid.com ([12.51.113.4]:62894 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759539AbZBYWTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:19:39 -0500
Date: Wed, 25 Feb 2009 17:19:49 -0500
From: Ed Cashin <ecashin@coraid.com>
To: David Miller <davem@davemloft.net>
Cc: roel.kluin@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] aoe: error printed 1 too early
Message-ID: <20090225221948.GF26634@coraid.com>
References: <49A549EE.7020202@gmail.com> <20090225170901.GA26634@coraid.com> <20090225.140136.74121676.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225.140136.74121676.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 02:01:36PM -0800, David Miller wrote:
> From: Ed Cashin <ecashin@coraid.com>
> Date: Wed, 25 Feb 2009 12:09:02 -0500
> 
> > Sounds like a good catch.  Did you find it because you saw the "cannot
> > free skb" message?
> 
> He's finding these by looking for them in the code, not by
> actually triggering the condition.

Thanks.  I was curious.

-- 
  Ed Cashin <ecashin@coraid.com>
