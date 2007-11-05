Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbXKER0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbXKER0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760610AbXKERTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:19:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbXKERTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:19:13 -0500
Date: Mon, 5 Nov 2007 12:19:09 -0500
From: Rik van Riel <riel@redhat.com>
To: Srini <v.vvsrini@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PAGE SIZE in Xeon (64 bit) processor
Message-ID: <20071105121909.6f7b8cab@bree.surriel.com>
In-Reply-To: <25b3869e0711050138n5e02cb19x23c441ba48052e07@mail.gmail.com>
References: <25b3869e0711050138n5e02cb19x23c441ba48052e07@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 15:08:47 +0530
Srini <v.vvsrini@gmail.com> wrote:

> Hi,
> 
> Is there a way currently (or in the near future to-be-released kernel
> version) where we can increase the PAGE SIZE in Xeon processor from
> 4KB to 64KB?

No, that is not supported by the hardware.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
