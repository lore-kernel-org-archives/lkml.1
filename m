Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYJ3P3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYJ3P3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYJ3P3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:29:30 -0400
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:41740 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbYJ3P3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:29:30 -0400
Date: Thu, 30 Oct 2008 10:28:40 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Paul Menage <menage@google.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] cpusets: per cpuset dirty ratios
In-Reply-To: <6599ad830810292359u6a2d0191ud235b866a73a7359@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810301028190.20953@quilx.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
  <alpine.DEB.1.10.0810280302320.15270@chino.kir.corp.google.com>
 <6599ad830810292359u6a2d0191ud235b866a73a7359@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Paul Menage wrote:

> Wouldn't this be equally applicable to cgroups using the memory
> controller rather than cpusets? Might it make sense to have a common
> subsystem that could be used by either of them?

Yes that would be useful.

