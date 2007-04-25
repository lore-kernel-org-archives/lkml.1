Return-Path: <linux-kernel-owner+w=401wt.eu-S1161865AbXDYSOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161865AbXDYSOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161868AbXDYSOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:14:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34385 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161865AbXDYSOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:14:48 -0400
Date: Wed, 25 Apr 2007 11:14:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070425180528.GH4730@kernel.dk>
Message-ID: <Pine.LNX.4.64.0704251113460.27844@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070425113530.GX9715@kernel.dk>
 <Pine.LNX.4.64.0704250833240.24452@schroedinger.engr.sgi.com>
 <20070425175335.GG4730@kernel.dk> <Pine.LNX.4.64.0704251101490.21918@schroedinger.engr.sgi.com>
 <20070425180528.GH4730@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Jens Axboe wrote:

> All of memory is lowmem. There are no bounces going on, for sure.

Could you figure out what this is? The patchset was intentionally only for 
64 bit. I cannot get to the 32 bit headaches for a week or so.

