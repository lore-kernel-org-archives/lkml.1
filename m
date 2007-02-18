Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbXBRLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbXBRLK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 06:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXBRLK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 06:10:57 -0500
Received: from mfront7.mail.yandex.net ([213.180.223.96]:51395 "EHLO
	mfront7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220AbXBRLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 06:10:56 -0500
Date: Sun, 18 Feb 2007 14:10:35 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D8342B.000001.29791@mfront7.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Accumulator (battery) discharging char driver
X-MsgDayCount: 7
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.221.32
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Where I can find an example of the driver (I'd like to make it simple, e.g. char device driver) for battery condition controlling. If the low level will be reached,
then this driver should inform user space application.

Thank you 
