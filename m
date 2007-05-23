Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbXEWRTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbXEWRTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXEWRTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:19:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53731 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756240AbXEWRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:19:22 -0400
Date: Wed, 23 May 2007 10:19:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <294534.72400.qm@web52611.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705231018480.20031@schroedinger.engr.sgi.com>
References: <294534.72400.qm@web52611.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Srihari Vijayaraghavan wrote:

> I'm personally very happy that slub works stably without slub debug options,
> because that's what I'd run in a production env. Thanks to your patch, slub is
> quite stable without the slub debug for me :-)). But it'd to nice to have a
> working slub debug for test env., as you'd undoubtedly be aware of, of course
> :-). Just my humble opinion.

Just switching off lockdep should make you happy until we figure out what 
is wrong?
