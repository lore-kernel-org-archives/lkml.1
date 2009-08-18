Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZHRWDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZHRWDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZHRWDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:03:05 -0400
Received: from ru.mvista.com ([213.79.90.228]:44049 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751455AbZHRWDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:03:03 -0400
Date: Wed, 19 Aug 2009 02:03:04 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] spi_mpc8xxx: Add support for DMA transfers
Message-ID: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In v2:

- Fix build issues in fsl_qe_udc;
- Some minor cosmetic changes in "Add support for QE DMA mode and
  CPM1/CPM2 chips" patch.


David/Greg, could you Ack drivers/usb/gadget/fsl_qe_udc.h's changes 
in "[PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for
non-QE/CPM builds", so we could merge that patch via powerpc tree?

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
