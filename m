Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbXC1VQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbXC1VQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXC1VQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:16:56 -0400
Received: from holomorphy.com ([66.93.40.71]:39961 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbXC1VQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:16:56 -0400
Date: Wed, 28 Mar 2007 14:16:58 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] i386: Remove page sized slabs for pgds and pmds
Message-ID: <20070328211658.GE2986@holomorphy.com>
References: <Pine.LNX.4.64.0703281309210.12985@schroedinger.engr.sgi.com> <20070328134511.0d61ec8f.akpm@linux-foundation.org> <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281401460.13743@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[... kernel compile garbage snipped ...]

On Wed, Mar 28, 2007 at 02:05:54PM -0700, Christoph Lameter wrote:
> Seems that there is a slight benefit but its also barely above noise 
> level.

I already went over the methodological issues with kernel compiles.
You may be able to prove this, but not this way.


-- wli
