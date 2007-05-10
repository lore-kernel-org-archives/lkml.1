Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXEJN4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXEJN4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbXEJN4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:56:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49967 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXEJN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:56:19 -0400
Message-Id: <20070510135152.178104939@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 15:51:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 00/15] s390 patches for 2.6.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixes, some compiler warnings and the Kconfig cleanup.
s390 now uses the common drivers/Kconfig file instead of the
home-brewn drivers/s390/Kconfig. There are some more config
options for s390 now, not all of them make sense but as long
as the code compiles no harm is done.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

