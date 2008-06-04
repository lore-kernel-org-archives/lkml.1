Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYFDQ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYFDQ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYFDQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:58:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYFDQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:58:49 -0400
Subject: Re: [PATCH 1/1] mtd m25p80: fix bug - ATmel spi flash fails to be
	copied to
From: David Woodhouse <dwmw2@infradead.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       mike@steroidmicros.com
In-Reply-To: <386072610805190253g42d47d81w794b3c14c15aa890@mail.gmail.com>
References: <1211021526-24076-1-git-send-email-cooloney@kernel.org>
	 <8A42379416420646B9BFAC9682273B6D0183AE38@limkexm3.ad.analog.com>
	 <386072610805190253g42d47d81w794b3c14c15aa890@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 17:58:43 +0100
Message-Id: <1212598723.32207.130.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 17:53 +0800, Bryan Wu wrote:
> 
> >
> > I just noticed that write_sr contains a duplicated spi_write.
> > Bryan sends out a new patch.
> >
> 
> 
> No problem, it is my fault. I should review the patch carefully.

Was there a new patch coming?

-- 
dwmw2

