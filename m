Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0CLKWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:22:39 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:35835 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab0CLKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:22:38 -0500
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2010 05:22:38 EST
Date: Fri, 12 Mar 2010 10:58:17 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: dinuxbg@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Add support for Olimex SAM9-L9261 Development board
Message-ID: <20100312105817.4392b594@rechenknecht2k7>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.81.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I was playing around with the Olimex SAM9-L9261 Development board and
noticed that the patches provided on the CD were not included in the
mainline kernel yet (while SAM9-L9260 is), and despite their
mailish format were never submitted anywhere.
The first patch is rather large as it contains sam9_l9261_defconfig.
I've cc'ed the original author.
