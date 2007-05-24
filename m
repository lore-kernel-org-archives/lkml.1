Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbXEXH1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbXEXH1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXEXH07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:26:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55095 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbXEXH07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:26:59 -0400
Date: Thu, 24 May 2007 09:25:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
Message-ID: <20070524072550.GC15375@kernel.dk>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com> <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com> <20070523071103.GE4705@kernel.dk> <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23 2007, Christoph Lameter wrote:
> On Wed, 23 May 2007, Jens Axboe wrote:
> 
> > That works for me with the patch, .config attached.
> 
> Hmmmm... That means the .config sent initially here was bogus.

?

Considering we're trying to help you fix bugs in your code, you could be
considerably more helpful.

-- 
Jens Axboe

