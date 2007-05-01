Return-Path: <linux-kernel-owner+w=401wt.eu-S1423630AbXEAUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423630AbXEAUuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946003AbXEAUuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:50:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50769 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423619AbXEAUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:49:47 -0400
Date: Tue, 1 May 2007 21:49:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/33] m68k patches for 2.6.22
Message-ID: <20070501204946.GB21080@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070501203234.252205858@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501203234.252205858@mail.of.borg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, is there any chance you could update m68k to use the generic
irq code?  The only architectures that don't have a conversion
in progress are m68k, m68knommu and arm26
