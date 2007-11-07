Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXKGSFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXKGSFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbXKGSFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:05:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40977 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757984AbXKGSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:05:21 -0500
Date: Wed, 7 Nov 2007 10:05:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, heiko.carstens@de.ibm.com
Subject: Re: [patch 00/28] cpu alloc v1: Optimize by removing arrays of
 pointers to per cpu objects
In-Reply-To: <1194441058.7744.9.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711071005070.9000@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <1194441058.7744.9.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Martin Schwidefsky wrote:

> The patch you provided for iucv has a few bugs which are corrected with
> the patch below (please merge with patch #25). With it new cpu alloc
> code works fine on s390. We likely want to switch to a virtual
> configuration as well. For now we can live with the static
> configuration.

Ok. Thanks!
