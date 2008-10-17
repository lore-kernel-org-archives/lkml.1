Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYJQN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYJQN7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYJQN7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:59:22 -0400
Received: from mail.suse.de ([195.135.220.2]:40315 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbYJQN7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:59:21 -0400
Date: Fri, 17 Oct 2008 15:59:10 +0200
From: Karsten Keil <kkeil@suse.de>
To: linux-kernel@vger.kernel.org
Subject: e1000e EEPROM corruption
Message-ID: <20081017135910.GA18206@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so after this ugly bug is finally fixed, here maybe left some victims of
this bug.

If here is still sombody who need help to recover from this issue,

I can probably help him, I successful recovered all machines on our side,
even one which do not longer show the NIC via lspci, so the only restiction
is, that the machine still boots and we have a NVM image of a similar
machine.
You should know the PCI ids of the NIC from the time before it crashed and
the MAC address.

-- 
Karsten Keil
SuSE Labs
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
