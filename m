Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab0CBFF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 00:05:57 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:40800 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CBFF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 00:05:56 -0500
Subject: yaffs2 NAND fs
From: Peter Paul <abnominales@web.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 06:05:54 +0100
Message-ID: <1267506354.1618.4.camel@virtubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19ZNb4mMDhW6JQVamBBG2yF8fP3S1ooX4Px6+AP
	y6V9DTPiTTfCGSHwNuekAwDrewgqov/91ovY/jxTFws1vgexKg
	YOE0nmJ0k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I was wondering why the yaffs2 file system has not gone for mainline
yet. It's rather popular flash file system in the embedded world, while
it is rather easy to patch a kernel to have yaffs2 support [1] it would
be even nicer if it was just in mainline.
The source of the GPLv2 file system can be found at [2]

[1] http://www.yaffs.net/howto-incorporate-yaffs 
[2] http://www.aleph1.co.uk/cgi-bin/viewcvs.cgi/yaffs2/

