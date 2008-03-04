Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbYCDXeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbYCDXeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934665AbYCDXbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:31:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37411 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbYCDXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:30:58 -0500
Subject: Re: [RFC] Notifier for Externally Mapped Memory (EMM)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
In-Reply-To: <1204673100.6241.59.camel@lappy>
References: <20080221144023.GC9427@v2.random>
	 <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random>
	 <20080302155457.GK8091@v2.random> <20080303213707.GA8091@v2.random>
	 <20080303220502.GA5301@v2.random> <47CC9B57.5050402@qumranet.com>
	 <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com>
	 <20080304133020.GC5301@v2.random>
	 <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com>
	 <20080304222030.GB8951@v2.random>
	 <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com>
	 <1204670529.6241.52.camel@lappy>
	 <Pine.LNX.4.64.0803041511080.21441@schroedinger.engr.sgi.com>
	 <1204673100.6241.59.camel@lappy>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 00:30:40 +0100
Message-Id: <1204673440.6241.61.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW, I'll cut the kvm and openfabrics lists from any future posts.
I'm getting tired of the bounces.

