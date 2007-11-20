Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXKTVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXKTVIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbXKTVH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:07:59 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:40767 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXKTVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:07:58 -0500
Subject: [patch] 0/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 20 Nov 2007 20:40:34 +0000
Message-Id: <1195591234.2329.52.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys.

This patchset contains support for three toshiba multifunction devices.

it introduces a small but useful bit of code as a library for similar
devices, and includes support for these chips on the toshiba e-series
family of handhelds.

please copy me on reply!

