Return-Path: <linux-kernel-owner+w=401wt.eu-S933083AbXDZGnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbXDZGnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933046AbXDZGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:43:07 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:34368 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933020AbXDZGnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:43:06 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 02:43:05 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0/2] Clean up  Intel RNG driver for 2.6.21-rc7-mm1
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Date: Thu, 26 Apr 2007 15:27:14 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF004332393@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Thread-Topic: [PATCH 0/2] Clean up  Intel RNG driver for 2.6.21-rc7-mm1
Thread-Index: AceHxfXqrUP+JUEwS/yJolfcdzlukQAARPxw
From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
To: <prarit@redhat.com>, <jbeulich@novell.com>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
       "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit and Jan,

Clean up Intel RNG driver for 2.6.21-rc7-mm1.
Patch 1/2 fixed the memory leak. 
Patch 2/2 fixed typo.

Please give me a comment.
--
Haruo
