Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbXFLPhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbXFLPhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXFLPhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:37:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43300 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbXFLPhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:37:04 -0400
Date: Tue, 12 Jun 2007 16:37:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, hch@infradead.org
Subject: Re: [PATCH] page table handling cleanup
Message-ID: <20070612153701.GA25038@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
	andi@firstfloor.org
References: <466E66F6.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E66F6.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 09:27:18AM +0200, Jan Beulich wrote:
> Kill pte_rdprotect(), pte_exprotect(), pte_mkread(), pte_mkexec(), pte_read(),
> pte_exec(), and pte_user() except where arch-specific code is making use of
> them.

Looks good.

