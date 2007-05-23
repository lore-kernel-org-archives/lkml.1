Return-Path: <linux-kernel-owner+w=401wt.eu-S935548AbXEWREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935548AbXEWREg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbXEWREG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:04:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759900AbXEWREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:04:04 -0400
Date: Wed, 23 May 2007 10:04:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070523071103.GE4705@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
 <20070523071103.GE4705@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Jens Axboe wrote:

> That works for me with the patch, .config attached.

Hmmmm... That means the .config sent initially here was bogus.

