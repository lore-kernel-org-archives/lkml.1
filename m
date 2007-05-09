Return-Path: <linux-kernel-owner+w=401wt.eu-S969539AbXEIB5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969539AbXEIB5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967846AbXEIB5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:57:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50663 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967186AbXEIB5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:57:07 -0400
Date: Tue, 8 May 2007 18:57:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070508.185539.95059076.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0705081856110.17784@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070508.185141.85412154.davem@davemloft.net>
 <Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>
 <20070508.185539.95059076.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, David Miller wrote:

> I'm just reading over the code to figure out what to type to you, you
> could read the code too it's not very complicated :-)

I have read it numerous times and my conclusion is that it uses the 
descriptors for that purpose. But Matt claims they are not necessary. So I 
am just trying to figure out how one can get to that conclusion.


