Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYFIMwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYFIMwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYFIMwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:52:37 -0400
Received: from nn7.de ([85.214.94.156]:49244 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbYFIMwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:52:37 -0400
Subject: 26-rc5+git hang on boot bluetooth hidd/hid_devices
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Jun 2008 12:52:28 +0000
Message-Id: <1213015948.7018.48.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updating to 2.6.26-rc5+git I recognize that debian sid suddenly hangs on
boot when bluetooth is activated. The last message I see is starting
hidd/hid_devices. And well 2.6.24/25 boot.

Does anybody else observe this? Any ideas?

Soeren
