Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbXJJJkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbXJJJkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbXJJJkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:40:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44607 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbXJJJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:40:20 -0400
Date: Wed, 10 Oct 2007 11:40:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Bowes <jbowes@dangerouslyinc.com>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation: Fix typo in SubmitChecklist.
In-Reply-To: <20071008185510.GA28549@crux.toronto.redhat.com>
Message-ID: <Pine.LNX.4.64.0710101139480.22916@fbirervta.pbzchgretzou.qr>
References: <20071008185510.GA28549@crux.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8 2007 14:55, James Bowes wrote:
> 20: Check that it all passes `make headers_check'.
> 
> 21: Has been checked with injection of at least slab and page-allocation
>-    fauilures.  See Documentation/fault-injection/.
>+    failures.  See Documentation/fault-injection/.

It was a fault injection, after all. :)
