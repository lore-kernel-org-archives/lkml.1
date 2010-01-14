Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161Ab0ANMcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0ANMcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085Ab0ANMcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:32:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:52548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab0ANMcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:32:35 -0500
Subject: Re: [PATCH 3/6] perf: Round robin groups of events using
 list_rotate_left()
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100114122921.GD5033@nowhere>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com>
	 <1263087500-14215-4-git-send-regression-fweisbec@gmail.com>
	 <1263471922.4244.311.camel@laptop>  <20100114122921.GD5033@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:32:13 +0100
Message-ID: <1263472333.4244.315.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 13:29 +0100, Frederic Weisbecker wrote:
> 
> But there is a subsequent patch in the same set
> that removes the rotating of pinned groups.

ok, let me read on ;-)

