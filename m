Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZFGMDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZFGMDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 08:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZFGMDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:03:41 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50071 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZFGMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:03:41 -0400
Date: Sun, 7 Jun 2009 14:03:42 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-ID: <20090607120342.GA14120@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604211103.4214303f.peter@piie.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

tested and working on Aspire One 110L, BIOS v0.3109 (oldest), 2.6.30-rc8,
including resume (short testing only, though).

It's a nice thing to be able to replace the less efficient
monitoring shell script stop-gap (many thanks to the people that provided this
very useful interim infrastructure, though!)

The current patch seems fine to me for inclusion,
and given Peter's prior performance I'm highly confident that a couple
rather minor review comments will get addressed, too.

Reviewed-by: Andreas Mohr <andi@lisas.de>
Tested-by: Andreas Mohr <andi@lisas.de>
