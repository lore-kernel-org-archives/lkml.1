Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbXJZPBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbXJZPBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXJZPBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:01:00 -0400
Received: from s131.mittwaldmedien.de ([62.216.178.31]:23538 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbXJZPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:00:58 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 11:00:57 EDT
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Date: Fri, 26 Oct 2007 16:55:07 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, rmk@arm.linux.org.uk, kernel@wantstofly.org,
       tony.luck@intel.com, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, paulus@samba.org, dmitry.torokhov@gmail.com,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-serial@vger.kernel.org, bryan.wu@analog.com, adaplas@gmail.com
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261655.07757.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  drivers/net/wireless/libertas/if_cs.c      |    2 +-

ACK
