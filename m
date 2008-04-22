Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbYDVXNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbYDVXNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYDVXNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:13:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbYDVXNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:13:21 -0400
Date: Tue, 22 Apr 2008 16:13:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 03 of 12] get_task_mm should not succeed if mmput() is
 running and has reduced
In-Reply-To: <20080422223727.GQ24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804221612290.4868@schroedinger.engr.sgi.com>
References: <a6672bdeead0d41b2ebd.1208872279@duo.random>
 <Pine.LNX.4.64.0804221323100.3640@schroedinger.engr.sgi.com>
 <20080422223727.GQ24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> On Tue, Apr 22, 2008 at 01:23:16PM -0700, Christoph Lameter wrote:
> > Missing signoff by you.
> 
> I thought I had to signoff if I conributed with anything that could
> resemble copyright? Given I only merged that patch, I can add an
> Acked-by if you like, but merging this in my patchset was already an
> implicit ack ;-).

No you have to include a signoff if the patch goes through your custody 
chain. This one did.

Also add a 

From: Christoph Lameter <clameter@sgi.com>

somewhere if you want to signify that the patch came from me. 
