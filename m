Return-Path: <linux-kernel-owner+w=401wt.eu-S934646AbYDQLPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646AbYDQLPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762409AbYDQLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:15:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11143 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbYDQLP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:15:29 -0400
Date: Thu, 17 Apr 2008 13:15:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: fix warning oops on rmmod of driver
Message-ID: <20080417111523.GC12774@kernel.dk>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk> <20080414172716.GM16584@beardog.cca.cpqcorp.net> <20080414173720.GQ12774@kernel.dk> <20080414174540.GO16584@beardog.cca.cpqcorp.net> <20080414175219.GR12774@kernel.dk> <20080416190040.GQ16584@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416190040.GQ16584@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> 
> * Fix oops on cciss rmmod due to calling pci_free_consistent with 
>   irqs disabled. 
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Applied

-- 
Jens Axboe

