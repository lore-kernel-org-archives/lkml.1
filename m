Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbYGSRxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbYGSRxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYGSRxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:53:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754707AbYGSRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:53:14 -0400
Date: Sat, 19 Jul 2008 10:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, riel@redhat.com
Subject: Re: [PATCH 1/8] slub: Add defrag_ratio field and sysfs support.
Message-Id: <20080719105239.4a89f64c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0807191529450.13345@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Were you planning on sending out the patches to wire all this up
to the notorious caches?
