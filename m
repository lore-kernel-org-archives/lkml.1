Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXC3HUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXC3HUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 03:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965034AbXC3HUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 03:20:45 -0400
Received: from mfront8.mail.yandex.net ([213.180.223.98]:54943 "EHLO
	mfront8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbXC3HUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 03:20:44 -0400
Date: Fri, 30 Mar 2007 11:20:26 +0400 (MSD)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <460CBA3A.000004.24212@mfront8.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: Problem: TX and RX interrupts occur at same time
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.230.13
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could someone help with the next problem:

When TX and RX interrupts occur at same time, then we have problem in iur tty driver. Is there any way to solve this problem. 

Thank you
