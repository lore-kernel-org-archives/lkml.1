Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYFBXLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYFBXLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYFBXLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:11:40 -0400
Received: from ozlabs.org ([203.10.76.45]:56670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbYFBXLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:11:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: initialization of static per-cpu variables
Date: Tue, 3 Jun 2008 09:11:23 +1000
User-Agent: KMail/1.9.9
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
References: <19f34abd0805211128r29fa437fm9e9e4c3d3c196f62@mail.gmail.com> <200805252035.24535.rusty@rustcorp.com.au> <20080602075937.GA29836@cs181133002.pp.htv.fi>
In-Reply-To: <20080602075937.GA29836@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030911.23987.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 17:59:37 Adrian Bunk wrote:
> On Sun, May 25, 2008 at 08:35:24PM +1000, Rusty Russell wrote:
> > Finally, it's a sparc64 problem and DaveM acked already.
>
> Was it a sparc64 problem or a generic problem DaveM happened to run into
> on sparc?

Yes, it was a sparc specific problem.

Rusty.
