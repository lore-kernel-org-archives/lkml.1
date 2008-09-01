Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYIALBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYIALBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYIALBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:01:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYIALB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:01:29 -0400
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO
	ioctl()
From: David Woodhouse <dwmw2@infradead.org>
To: Zev Weiss <zevweiss@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <48B4D884.5040204@gmail.com>
References: <48ABCC0B.40607@gmail.com>
	 <20080822153451.bb79bd1f.akpm@linux-foundation.org>
	 <48AFC5ED.50005@gmail.com>
	 <20080823222707.2fb972b5.akpm@linux-foundation.org>
	 <48B13F88.3080306@gmail.com>  <48B4D884.5040204@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 12:01:24 +0100
Message-Id: <1220266884.2982.62.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 21:31 -0700, Zev Weiss wrote:
> Well, for what little it's probably worth, I've now tested this patch, with no 
> resulting surprises (seems to work fine for me).  Though I see now that, much to 
> my chagrin, something in my email chain seems to have spacified my code.  If 
> there's any need I can resend appropriately.

Please. With a signed-off-by.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



