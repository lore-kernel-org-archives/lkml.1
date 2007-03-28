Return-Path: <linux-kernel-owner+w=401wt.eu-S1750982AbXC1WWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbXC1WWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXC1WWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:22:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58046 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982AbXC1WWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:22:18 -0400
Date: Wed, 28 Mar 2007 15:22:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328220131.GF2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281513210.14151@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328205055.GX8915@holomorphy.com> <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com>
 <20070328212459.GY8915@holomorphy.com> <Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com>
 <20070328220131.GF2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> On Wed, Mar 28, 2007 at 02:38:55PM -0700, Christoph Lameter wrote:
> > No that was described in the patch. Quote:
> > "i386 only provides support for caching constructed pgd and pmds. These 
> > are comparatively rare to ptes so it is no surprise that the current 
> > approach has only minimal effect. ...."
> 
> And where was the mention of this being a patch I sent you in a private
> reply verbatim, and furthermore asked you not to post?

Yes it was private and you told me to be careful about "waving this patch 
around". No mention of not posting it.

And I repeat that I am sorry to have removed the paragraph that mentioned 
you being the author during rewrites of the text. Signoff line is there. 
This is an RFC so we can still add this if we want to apply it at all.

I think we need to discuss this openly. It seems that I am getting into 
unknown minefields of an ancient discussion between you and Andrew.



