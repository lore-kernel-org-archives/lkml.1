Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXCZUih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXCZUih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXCZUih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:38:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXCZUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:38:36 -0400
Date: Mon, 26 Mar 2007 21:38:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Message-ID: <20070326203824.GA1430@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	linux-scsi@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6> <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org> <1174941347.3549.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174941347.3549.41.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 03:35:47PM -0500, James Bottomley wrote:
> I agree the non-legacy (CardBus and beyond) ones can be built in.  I
> thought the legacy 8 and 16 bit type I and II still had to be modular
> because they still need setting up.

nope.  While I don't have a pcmcia scsi card my 16 bit pcmcia wireless
cards work perfectly fine without any previous setup.

