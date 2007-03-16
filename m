Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbXCPHvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbXCPHvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXCPHvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:51:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39604 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbXCPHvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:51:38 -0400
Date: Fri, 16 Mar 2007 09:51:36 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
In-Reply-To: <45FA4C59.1000908@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0703160951200.15253@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
 <45FA458C.8050605@yahoo.com.au> <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
 <45FA4984.9000506@yahoo.com.au> <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
 <45FA4C59.1000908@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, Nick Piggin wrote:
> So I think you really do need to get back to the mm, and then search its
> vmas.

You're right.
