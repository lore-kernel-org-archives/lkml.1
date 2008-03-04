Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYCDNVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYCDNVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 08:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYCDNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 08:21:21 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:55460
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbYCDNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 08:21:20 -0500
Date: Tue, 4 Mar 2008 14:21:18 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: izik eidus <izike@qumranet.com>
Cc: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] KVM swapping with mmu notifiers #v9
Message-ID: <20080304132118.GB5301@v2.random>
References: <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random> <20080303213707.GA8091@v2.random> <20080303220502.GA5301@v2.random> <47CC9B57.5050402@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC9B57.5050402@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Izik,

On Tue, Mar 04, 2008 at 02:44:07AM +0200, Izik Eidus wrote:
> i wrote to you about this before (i didnt get answer for this so i write 

Ouch I must have lost your previous comment with a too-fast pgdown in
the full quoting of the patch sorry.

> again)
> with large pages support i think we need to use here put_page

Right, thanks!!
