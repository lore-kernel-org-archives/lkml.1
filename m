Return-Path: <linux-kernel-owner+w=401wt.eu-S933432AbYDVWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbYDVWiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761176AbYDVWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:37:42 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59133
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009AbYDVWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:37:41 -0400
Date: Wed, 23 Apr 2008 00:37:27 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
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
Message-ID: <20080422223727.GQ24536@duo.random>
References: <a6672bdeead0d41b2ebd.1208872279@duo.random> <Pine.LNX.4.64.0804221323100.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221323100.3640@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:23:16PM -0700, Christoph Lameter wrote:
> Missing signoff by you.

I thought I had to signoff if I conributed with anything that could
resemble copyright? Given I only merged that patch, I can add an
Acked-by if you like, but merging this in my patchset was already an
implicit ack ;-).
