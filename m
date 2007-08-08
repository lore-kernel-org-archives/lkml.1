Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbXHHFbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbXHHFbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 01:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXHHFbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 01:31:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:48532 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXHHFbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 01:31:41 -0400
Message-Id: <20070808052842.451400000@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 07 Aug 2007 22:28:42 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: [patch 0/6] Convert from class_device to device [char, hwmon, video]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/char, drivers/hwmon and drivers/video from struct class_device
to struct device.  Toward end-goal of removing class_device.
-- 
