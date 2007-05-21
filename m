Return-Path: <linux-kernel-owner+w=401wt.eu-S1764319AbXEUTHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764319AbXEUTHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXEUTGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:06:54 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:40462 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbXEUTGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:06:53 -0400
Date: Mon, 21 May 2007 20:06:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070521190043.GA4705@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705212005110.2550@blonde.wat.veritas.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211930370.31659@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705211147100.26970@schroedinger.engr.sgi.com>
 <20070521190043.GA4705@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABmluYm94AHNyaWhhcml2aWpheWFyYWdoYXZhbkB5YWhvby5jb20uYXUAb3h5bW9yb25Ad2FzdGUub3JnAGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBqZW5zLmF4Ym9lQG9yYWNsZS5jb20AYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Jens Axboe wrote:
> 
> I can test whatever you want tomorrow morning, it was 100% repeatable
> here. So which one, your patch or Hughs?

Great, thanks: Christoph's please - I'm sure he'll agree!

Hugh
