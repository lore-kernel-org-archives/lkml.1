Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbXBNS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbXBNS7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXBNS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:59:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35613 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbXBNS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:59:35 -0500
Date: Wed, 14 Feb 2007 18:59:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org,
       raisch@de.ibm.com, h.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 1/5] ehca: reworked irq handler to avoid/reduce missed irq events
Message-ID: <20070214185907.GA15105@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
	Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, openib-general@openib.org,
	raisch@de.ibm.com, h.carstens@de.ibm.com
References: <200702141740.48286.hnguyen@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702141740.48286.hnguyen@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 05:40:47PM +0100, Hoang-Nam Nguyen wrote:
> Hi,
> here is a patch for ehca with the reworked irq handler.
> Thanks
> Nam

This looks okay to me (and sorry for new replying earlier to you private
mail)
