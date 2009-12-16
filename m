Return-Path: <linux-kernel-owner+w=401wt.eu-S934769AbZLPIRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769AbZLPIRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934710AbZLPIRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:17:15 -0500
Received: from mx51.mymxserver.com ([85.199.173.110]:61141 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679AbZLPIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:17:14 -0500
X-Greylist: delayed 78287 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 03:17:14 EST
From: Holger Schurig <holgerschurig@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] Libertas: fix buffer overflow in lbs_get_essid()
Date: Wed, 16 Dec 2009 09:15:35 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Maithili Hinge <maithili@marvell.com>,
       Kiran Divekar <dkiran@marvell.com>,
       Michael Hirsch <m.hirsch@raumfeld.com>, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, linux-wireless@lists.infradead.org,
       stable@kernel.org
References: <1260936778-2096-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1260936778-2096-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912160915.35540.holgerschurig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Dan didn't answer:

Acked-by: Holger Schurig <holgerschurig@gmail.com>

-- 
http://www.holgerschurig.de
