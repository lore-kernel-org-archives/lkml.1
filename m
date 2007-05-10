Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXEJMoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXEJMoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbXEJMoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:44:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:38857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbXEJMoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:44:17 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
References: <20070508194845.GC24114@agk.fab.redhat.com>
	<20070508174159.7d78a275.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 May 2007 15:41:38 +0200
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
Message-ID: <p73fy64g5il.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> I have this vague memory from a long time ago that one particular CPU type
> wants to go oops when prefetching from an invalid address.

AMD K7/K8, but we got a generic workaround for a long time.

-Andi
