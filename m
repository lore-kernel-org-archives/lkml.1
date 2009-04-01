Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbZDALxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbZDALxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDALxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:53:10 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52449 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762663AbZDALxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:53:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18899.18161.598498.143604@cargo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 21:50:25 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/15] perf_counter tools: optionally scale counter
	values in perfstat mode
In-Reply-To: <20090401093942.GB27865@elte.hu>
References: <20090330170701.856843742@chello.nl>
	<20090330171023.871484899@chello.nl>
	<20090401093942.GB27865@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Nice! Shouldnt this be the default mode of output?

I agree, it should.

> I think we want to make users aware of the fact when output is 
> sampled due to over-commit, rather than precise, agreed?

Definitely.

Paul.
