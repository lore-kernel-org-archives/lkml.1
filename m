Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYDNUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYDNUAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbYDNT74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:59:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55741 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757376AbYDNT7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:59:55 -0400
Date: Mon, 14 Apr 2008 12:59:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2 of 9] Core of mmu notifiers
In-Reply-To: <baceb322b45ed4328065.1207669445@duo.random>
Message-ID: <Pine.LNX.4.64.0804141259440.7803@schroedinger.engr.sgi.com>
References: <baceb322b45ed4328065.1207669445@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where is the documentation on locking that you wanted to provide?


