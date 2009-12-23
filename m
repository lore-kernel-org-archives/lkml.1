Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZLWVf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZLWVf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZLWVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:35:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:40680 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZLWVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:35:25 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: joe@perches.com
Subject: get_maintainers.pl & acer-wmi
Date: Wed, 23 Dec 2009 21:35:33 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.31.5; KDE/4.3.4; x86_64; ; )
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org, len.brown@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912232135.33356.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

We're getting some odd results out of get_maintainers.pl for acer-wmi.

ccorbacho@pacifica:~/src/kernel/linux-2.6$ perl scripts/get_maintainer.pl -f 
drivers/platform/x86/acer-wmi.c

Carlos Corbacho <carlos@strangeworlds.co.uk>
John W. Linville <linville@tuxdriver.com>
Len Brown <len.brown@intel.com>
Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Johannes Berg <johannes@sipsolutions.net>
linux-kernel@vger.kernel.org

Which is odd, as I'm the only maintainer of acer-wmi, so why does it pull in 
all the other names above?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
