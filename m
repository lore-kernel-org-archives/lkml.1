Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXGJNGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXGJNGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXGJNGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:06:39 -0400
Received: from host.infinivid.com ([64.119.179.76]:41020 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbXGJNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:06:38 -0400
Subject: Driver question: multiple instances of same char device
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 09:06:36 -0400
Message-Id: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am relatively new to linux device development. And want to understand
Linux conventions.

Suppose I have a PCI card that is represented in the system by a
character device.

If I have two of those PCI cards in the system when the driver module
loads, is it convention to have two different major numbers, or have one
major number and two different minor numbers?

Thanks,
Jon

