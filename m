Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703Ab0AaWQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0AaWQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 17:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181Ab0AaWQP
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 17:16:15 -0500
Received: from rekin23.go2.pl ([193.17.41.16]:50814 "EHLO rekin23.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0AaWQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 17:16:15 -0500
Subject: =?UTF-8?Q?[regression_2.6.33_rc3-rc5]_sata=5Fnv_and_no_/dev_files?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <1f9bac08.1a5266d6.4b66012a.5a11a@o2.pl>
Date: Sun, 31 Jan 2010 23:16:10 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Found regression as in topic.
cat /proc/partitions shows partitions but fstab cant mount because no /dev/sdxx files.
Have chacked on rc4 and rc5 and dont rememmber if rc3 is affected, but it could.
rc1 is abs ok.
If any more info needed please ask.
udev 151

Best regards.
Bartlomiej Zimon
