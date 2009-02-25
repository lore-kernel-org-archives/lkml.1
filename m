Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZBYTeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZBYTeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZBYTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:34:35 -0500
Received: from kuber.nabble.com ([216.139.236.158]:32986 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZBYTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:34:34 -0500
Message-ID: <22210028.post@talk.nabble.com>
Date: Wed, 25 Feb 2009 11:34:29 -0800 (PST)
From: anitemp <marathe.aniruddha@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.x kernel debugging over ethernet (without serial connection)
 and reboot
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: marathe.aniruddha@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I am trying to debug my USB Gadget driver. I have two machines connected to
the LAN and the driver is running on one of them. However, there is no
serial or ethernet null-modem connection between them.

At some point in time, the kernel freezes due to my buggy driver (I am
suspecting unreleased lock) In this situation I need to be able to reboot
the frozen host remotely from the other host.

I searched on the net and on the forum but did not find material which would
serve this purpose, although I found a few useful tutorials on KGDB in
general.

Please let me know if there any way of doing this.

Thanks for your time!

-Aniruddha
-- 
View this message in context: http://www.nabble.com/2.6.x-kernel-debugging-over-ethernet-%28without-serial-connection%29-and-reboot-tp22210028p22210028.html
Sent from the linux-kernel mailing list archive at Nabble.com.

