Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbYBMAGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbYBMAGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYBMAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:05:51 -0500
Received: from khc.piap.pl ([195.187.100.11]:47537 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYBMAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:05:50 -0500
To: "Kok\, Auke" <auke-jan.h.kok@intel.com>
Cc: Prakash Punnoor <prakash@punnoor.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: E1000 (PCI-E) doesn't work on nforce430, MSI issue.
References: <m37ih9ooim.fsf@maximus.localdomain>
	<200802122234.47164.prakash@punnoor.de> <47B21C95.4050705@intel.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 13 Feb 2008 01:05:49 +0100
In-Reply-To: <47B21C95.4050705@intel.com> (Auke Kok's message of "Tue\, 12 Feb 2008 14\:24\:21 -0800")
Message-ID: <m3d4r1bu02.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kok, Auke" <auke-jan.h.kok@intel.com> writes:

>>> Don't work by default. "pci=nomsi" fixes the problem.
>
> actually does not fix anything - it just works around it by falling
> back to legacy interrupts.

Actually it does, fixes the problem by working around a bug :-)

Thanks for info.
-- 
Krzysztof Halasa
