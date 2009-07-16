Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZGPOQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZGPOQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZGPOQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:16:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:60393 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZGPOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:16:37 -0400
Subject: Re: [patch 0/5] Various perfcounter fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090716104247.536695580@samba.org>
References: <20090716104247.536695580@samba.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 16:16:32 +0200
Message-Id: <1247753792.6586.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 20:42 +1000, Anton Blanchard wrote:
> Here are a few more perfcounter fixes, and one patch that changes the
> call graph option to be consistent between perf record and perf report.
> Perhaps I'm too late on that one, but I thought I'd give it a try :)

Nice catch on 1, and agreed on the others as well. Thanks!

I'll see what I can do to make this land in .31.

