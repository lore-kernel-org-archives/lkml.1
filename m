Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYE3Gsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYE3Gsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYE3Gsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:48:39 -0400
Received: from ozlabs.org ([203.10.76.45]:48271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbYE3Gsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:48:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 05/41] cpu alloc: Percpu_counter conversion
Date: Fri, 30 May 2008 16:47:35 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040012.011711936@sgi.com>
In-Reply-To: <20080530040012.011711936@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301647.36198.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2008 13:56:25 Christoph Lameter wrote:
> Use cpu_alloc instead of allocpercpu.

These patches seem like useless churn.

Plus, the new code is uglier than the old code :(

Rusty.
