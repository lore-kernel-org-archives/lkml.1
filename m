Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXGIPpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXGIPpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXGIPo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:44:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47246 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753044AbXGIPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:44:58 -0400
Date: Mon, 9 Jul 2007 08:44:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/vmstat.c: cleanups
In-Reply-To: <20070709145720.GB3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707090844390.13783@schroedinger.engr.sgi.com>
References: <20070705232345.GG3492@stusta.de>
 <Pine.LNX.4.64.0707061048310.30575@schroedinger.engr.sgi.com>
 <20070706181350.GO3492@stusta.de> <Pine.LNX.4.64.0707061221330.24163@schroedinger.engr.sgi.com>
 <20070709145720.GB3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Adrian Bunk wrote:

> > Then just remove the whole function. the #if 0 is ugly.
> 
> Updated patch below.

Thanks.

Acked-by: Christoph Lameter <clameter@sgi.com>
