Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXGUWz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXGUWz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXGUWzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:55:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:35336 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbXGUWzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:55:14 -0400
To: Lars Ellenberg <lars@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
References: <20070721203819.GA10706@mail.linbit.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Jul 2007 01:50:09 +0200
In-Reply-To: <20070721203819.GA10706@mail.linbit.com>
Message-ID: <p73hcnxuxji.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Ellenberg <lars@linbit.com> writes:
> 
> Jens, Andrew, anyone: please review,
> and give me advice how to proceed from here.

The standard procedure would be to post all the source code in logical
pieces on the list for review. Then iterate until all comments are addressed.

-Andi

