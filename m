Return-Path: <linux-kernel-owner+w=401wt.eu-S965204AbZLQWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204AbZLQWn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936766AbZLQWnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:43:52 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:10841 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936765AbZLQWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:43:51 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMNCKkurR7H+/2dsb2JhbAC+YJcrhC0EgWM
X-IronPort-AV: E=Sophos;i="4.47,415,1257120000"; 
   d="scan'208";a="64390820"
From: Roland Dreier <rdreier@cisco.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No PCI-X / PCI-E cards ...
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Dec 2009 14:43:48 -0800
In-Reply-To: <1261089592.8827.5.camel@bip> (Xavier Bestel's message of "Thu,
	17 Dec 2009 23:39:52 +0100")
Message-ID: <adahbrp43x7.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Dec 2009 22:43:49.0300 (UTC) FILETIME=[664C0740:01CA7F6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > [    0.184098] pci 0000:00:1c.0: BAR 13: can't allocate resource

When does this message appear?  Does it matter if the PCIe card is
installed or not?  This 0000:00:1c.0 device is:

> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)

so it might be relevant.

Did you try all the PCIe slots?

