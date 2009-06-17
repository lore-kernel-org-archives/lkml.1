Return-Path: <linux-kernel-owner+w=401wt.eu-S1761418AbZFQWpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418AbZFQWpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbZFQWpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:45:18 -0400
Received: from claw.goop.org ([74.207.240.146]:57057 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760141AbZFQWpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:45:17 -0400
Message-ID: <4A3971FE.7040700@goop.org>
Date: Wed, 17 Jun 2009 15:45:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: init_emergency_isa_pool calling mempool_create in non-sleeping
 context
References: <4A396195.8060503@goop.org> <0f79c2d4513c50184383e223d3d2ee97.squirrel@neil.brown.name> <20090617224219.GA9405@redhat.com>
In-Reply-To: <20090617224219.GA9405@redhat.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 15:42, Mike Snitzer wrote:
> This has been resolved and is waiting to be pushed along with the rest
> of the DM changes for 2.6.31.
>
> See:
> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-table-establish-queue-limits-by-copying-table-limits.patch
>   

OK, good to know.

> Maybe this fix should go now rather than wait a day or so for the larger
> DM push?
>   

The machine booted fine with no apparent badness, so I don't think its
urgent.  I just reported it for diligence's sake.

    J
