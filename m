Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbXC1VUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbXC1VUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXC1VUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:20:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51712 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753092AbXC1VUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:20:22 -0400
Date: Wed, 28 Mar 2007 14:20:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
In-Reply-To: <20070328211658.GE2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0703281418040.13870@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com>
 <20070328134511.0d61ec8f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
 <20070328211658.GE2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, William Lee Irwin III wrote:

> On Wed, Mar 28, 2007 at 02:05:54PM -0700, Christoph Lameter wrote:
> > Seems that there is a slight benefit but its also barely above noise 
> > level.
> 
> I already went over the methodological issues with kernel compiles.
> You may be able to prove this, but not this way.

But this way is an established kernel way of doing things. Seems that my 
AIM9 stuff was not convincing and I am not sure what other tests would be 
acceptable. Could you post some of data regarding the improvements 
possible through your patches?
