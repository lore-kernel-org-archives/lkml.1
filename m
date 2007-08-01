Return-Path: <linux-kernel-owner+w=401wt.eu-S934915AbXHAPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915AbXHAPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934771AbXHAPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:18:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50427 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934762AbXHAPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:18:15 -0400
Date: Wed, 1 Aug 2007 16:18:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
Message-ID: <20070801151812.GA17601@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <46B0A30A.8090500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B0A30A.8090500@googlemail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 05:13:14PM +0200, Michal Piotrowski wrote:
> Hi,
> 
> Coding style fix
> 
> Regards,
> Michal
>

I think that include should just go.  There is no reason at all for
a scsi driver to include stat.h

