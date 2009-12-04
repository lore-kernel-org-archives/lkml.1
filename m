Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZLDBw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZLDBw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbZLDBw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:52:26 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39974 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbZLDBwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:52:25 -0500
Message-Id: <1259891550.19943.1348372917@webmail.messagingengine.com>
X-Sasl-Enc: Ats8HmdO8YkLEd2IIl9WWRXGcLgT2cIc4ICBg8qDAIKp 1259891550
From: myuboot@fastmail.fm
To: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com><4AD906D8.3020404@caviumnetworks.com><1255996564.10560.1340920621@webmail.messagingengine.com><200910200817.24018.florian@openwrt.org><1256676013.24305.1342273367@webmail.messagingengine.com>
 <20091028103551.0b4052d8@pixies.home.jungo.com>
Subject: PIR OFFSET for AR7
In-Reply-To: <20091028103551.0b4052d8@pixies.home.jungo.com>
Date: Thu, 03 Dec 2009 19:52:30 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, What is the use of PIR register for AR7 board in file
arch/mips/ar7/irq.c? If I understand it right, PIR is used to define the
polarity of the interrupts. It seems to me that it needs to initialized?

Best regards, Andrew
