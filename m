Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYB0Wzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYB0Wzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYB0Wzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:55:31 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52463 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbYB0Wza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:55:30 -0500
Date: Wed, 27 Feb 2008 14:55:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrea Arcangeli <andrea@qumranet.com>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch] my mmu notifiers
In-Reply-To: <20080219225923.GA18912@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0802271454430.13186@schroedinger.engr.sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
 <20080219225923.GA18912@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Nick Piggin wrote:

> I thought that could be used by a non-sleeping user (not intending
> to try supporting sleeping users). If it is useless then it should
> go away (BTW. I didn't see your recent patch, some of my confusion
> I think stems from Christoph's novel way of merging and splitting
> patches).

What is so novel about introducing functionality step by step?
