Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbXKSEO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbXKSEO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 23:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXKSEOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 23:14:21 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:8273 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbXKSEOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 23:14:21 -0500
Message-ID: <1618816c0711182014n293b9429y53bfcf219a624260@mail.gmail.com>
Date: Sun, 18 Nov 2007 21:14:18 -0700
From: "Raymano Garibaldi" <raymano@faunos.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] USB_PERSIST
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel 2.6.23.8 USB_PERSIST feature does not work if the same USB
device is detached and reattached while computer is suspended. The
mount points for the USB storage device mounted before suspend are
lost and the device has to be remounted after resume.

Please advise,
Thank you,
Raymano Garibaldi
