Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbZHSMpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbZHSMpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZHSMpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:45:20 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:47951 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbZHSMpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:45:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
Date: Wed, 19 Aug 2009 22:36:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
In-Reply-To: <20090819092023.980284148@chello.nl>
References: <20090819091823.916851355@chello.nl>
	<20090819092023.980284148@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Provide the ability to configure a counter to send its output to
> another (already existing) counter's output stream.

What sort of thing might this be useful for?

Does this only apply to sampling counters?

Paul.
