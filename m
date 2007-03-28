Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXC1WB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXC1WB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXC1WB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:01:28 -0400
Received: from holomorphy.com ([66.93.40.71]:60409 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372AbXC1WB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:01:27 -0400
Date: Wed, 28 Mar 2007 15:01:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328220131.GF2986@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328205055.GX8915@holomorphy.com> <Pine.LNX.4.64.0703281356080.13258@schroedinger.engr.sgi.com> <20070328212459.GY8915@holomorphy.com> <Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281435330.14017@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 02:38:55PM -0700, Christoph Lameter wrote:
> No that was described in the patch. Quote:
> "i386 only provides support for caching constructed pgd and pmds. These 
> are comparatively rare to ptes so it is no surprise that the current 
> approach has only minimal effect. ...."

And where was the mention of this being a patch I sent you in a private
reply verbatim, and furthermore asked you not to post?


-- wli
