Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZLCT2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZLCT2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbZLCT2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:28:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:41825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbZLCT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:28:48 -0500
Subject: Re: What is the performance when using frame pointers in the
 kernel?
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan>
References: <alpine.DEB.2.00.0912031235230.6768@p34.internal.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 20:28:49 +0100
Message-ID: <1259868529.3977.1300.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 12:36 -0500, Justin Piszcz wrote:

> What is the performance hit when the kernel is compiled with frame 
> pointers?

build both kernels and run your favourite workload to find out.

