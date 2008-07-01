Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYGAOpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYGAOpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYGAOpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:45:08 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:37958 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYGAOpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:45:07 -0400
Date: Tue, 1 Jul 2008 16:44:30 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       jang@linux.vnet.ibm.com, Swen Schillig <swen@vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 5/5] zfcp: adapt to new qdio driver
Message-ID: <20080701144429.GA13260@schmichrtp.de.ibm.com>
References: <20080701140551.168274793@de.ibm.com> <20080701140625.489478465@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701140625.489478465@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 04:05:56PM +0200, Martin Schwidefsky wrote:
> From: Jan Glauber <jang@linux.vnet.ibm.com>
> 
> - cleanup qdio interface error handling
> - remove qdio interface threshold values
> - remove do_QDIO unused last parameter
> - no more -EINPROGRESS from qdio_shutdown()
> - remove unused parameter from qdio_activate()
> - remove QDIO_FLAG_UNDER_INTERRUPT
> 
> Cc: Swen Schillig <swen@vnet.ibm.com>
> Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

ACK

Christof
