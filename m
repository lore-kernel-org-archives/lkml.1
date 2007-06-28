Return-Path: <linux-kernel-owner+w=401wt.eu-S1764443AbXF1QlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764443AbXF1QlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbXF1QlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:41:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:35866 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301AbXF1QlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:41:13 -0400
Message-Id: <20070628164049.118610355@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 28 Jun 2007 18:40:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm-devel@lists.sourceforge.net, linux-mm@kvack.org
Subject: [patch 0/6] resend: guest page hinting version 5.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
after Carsten pitched CMM2 on the kvm mini summit here is a repost
of version 5 of the guest page hinting patches. The code is still
the same but has been adapted to the latest git level.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

