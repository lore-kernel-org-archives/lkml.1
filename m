Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZAKHyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZAKHyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZAKHyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:54:24 -0500
Received: from 8bytes.org ([88.198.83.132]:41424 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZAKHyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:54:24 -0500
Date: Sun, 11 Jan 2009 08:54:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: [PATCH 08/16] dma-debug: add core checking functions
Message-ID: <20090111075423.GH9466@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1231517970-20288-9-git-send-email-joerg.roedel@amd.com> <20090110231222.GL17917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110231222.GL17917@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 12:12:22AM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +	/*
> > +	 *          * This may be no bug in reality - but most implementations of the
> > +	 *                   * DMA API don't handle this properly, so check for it here
> > +	 *                            */
> 
> You must be using Vim and copy & paste messed up? :)

Ups, true :) Thanks.

Joerg
