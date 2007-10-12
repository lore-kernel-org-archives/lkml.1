Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbXJLDFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbXJLDFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbXJLDFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:05:12 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36798 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbXJLDFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:05:08 -0400
X-IronPort-AV: i="4.21,263,1188792000"; 
   d="scan'208"; a="41596813:sNHT17486042"
From: Bryan Wu <bryan.wu@analog.com>
To: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 00/10] Blackfin SPI driver updates for 2.6.24
Date: Fri, 12 Oct 2007 11:04:54 +0800
Message-Id: <1192158304-8277-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 - add BF54x support
 - add multi SPI ports support
 - fixup some bugs
