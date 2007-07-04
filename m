Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbXGDMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbXGDMF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDMFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:05:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:59313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761496AbXGDMFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:05:08 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
References: <20070703185116.59c8f5f5@the-village.bc.nu>
From: Andi Kleen <andi@firstfloor.org>
Date: 04 Jul 2007 15:00:26 +0200
In-Reply-To: <20070703185116.59c8f5f5@the-village.bc.nu>
Message-ID: <p73k5tg2uj9.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> Post SRST 
What is SRST?

My personal wish list feature would be a little forwarder driver
to forward /dev/hd* to /dev/sd* for this; then old IDE could be
disabled without risking breaking old root file systems.

-Andi
