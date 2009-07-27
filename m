Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbZG0FMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbZG0FMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZG0FMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:12:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZG0FMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:12:23 -0400
Date: Mon, 27 Jul 2009 01:12:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Hans-Joachim Picht <hans@linux.vnet.ibm.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arnd Schneider <arnd@de.ibm.com>, linux-fsdevel@vger.kernel.org
Subject: Re: PM/hibernate swapfile regression
Message-ID: <20090727051217.GA24854@infradead.org>
References: <20090714135453.GA26976@osiris.boeblingen.de.ibm.com> <4A659D75.3050004@tuffmail.co.uk> <20090721215536.GA9502@infradead.org> <200907252358.26434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907252358.26434.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 11:58:25PM +0200, Rafael J. Wysocki wrote:
> Thanks for the comments.  Does the one below look better?

Yes, that looks much better to me.

