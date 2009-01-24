Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZAXOcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZAXOcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZAXOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:32:08 -0500
Received: from blu0-omc1-s5.blu0.hotmail.com ([65.55.116.16]:15030 "EHLO
	blu0-omc1-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191AbZAXOcH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:32:07 -0500
Message-ID: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl>
X-Originating-IP: [84.216.37.216]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: EXTRA_VERSION in #if LINUX_VERSION_CODE >= KERNEL_VERSION(x,x,x)
Date: Sat, 24 Jan 2009 15:32:06 +0100
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Jan 2009 14:32:07.0002 (UTC) FILETIME=[887A5BA0:01C97E30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How does one write stuff like
#if LINUX_VERSION_CODE>= KERNEL_VERSION(2,6,28)
if the 4 digit EXTRA_VERSION also is needed?


_________________________________________________________________
Hitta bästa priserna på MSN Shopping!
http://shopping.msn.se/co_16199-msn-shopping.html