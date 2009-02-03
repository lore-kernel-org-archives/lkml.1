Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZBCOYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZBCOYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZBCOYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:24:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51836 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZBCOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:24:39 -0500
Subject: Re: [patch 1/2] slqb: fix small zero size alloc bug
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090203135559.GA8723@wotan.suse.de>
References: <20090203135559.GA8723@wotan.suse.de>
Date: Tue, 03 Feb 2009 16:24:36 +0200
Message-Id: <1233671076.22926.56.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 14:55 +0100, Nick Piggin wrote:
> Fix a problem where SLQB did not correctly return ZERO_SIZE_PTR for a
> zero sized allocation.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Applied, thanks!

