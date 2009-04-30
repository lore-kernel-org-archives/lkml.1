Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbZD3I3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbZD3I3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZD3I25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:28:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:32834 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759994AbZD3I2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:28:55 -0400
Message-Id: <1241080135.32735.1313058447@webmail.messagingengine.com>
X-Sasl-Enc: drLBEIh5xNysn2nDZo0xg3E5bYMuzBU2NcqMVBehH3PT 1241080135
From: "Jack Stone" <jwjstone@fastmail.fm>
To: linux@arm.linux.org.uk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Arm and allyesconfig, allnoconfig, allmodconfig and randconfig
Date: Thu, 30 Apr 2009 10:28:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been trying to compile the Arm port of the kernel and noticed that
allyesconfig etc. and randconfig don't seem to compile on Arm - they all
end up with build errors (mostly about missing preprocessor defines eg
__LINUX_ARM_ARCH__). Is this a known problem and if so can it be
documented somewhere?

As another data point I can compile the defconfigs fine.

I tried googling and greping the source for any reference to this but
couldn't see anything. Sorry if this has already been answered.

Thanks,

Jack
