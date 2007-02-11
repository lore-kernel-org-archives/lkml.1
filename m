Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbXBKNgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbXBKNgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 08:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932842AbXBKNgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 08:36:47 -0500
Received: from tag.witbe.net ([81.88.96.48]:45156 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830AbXBKNgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 08:36:46 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: <rol@as2917.net>, "'Benoit Boissinot'" <bboissin@gmail.com>,
       <rol@witbe.net>, "'Olaf Hering'" <olaf@aepfle.de>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.20/2.6.20-rc7 : ethX renumbered
Date: Sun, 11 Feb 2007 14:35:56 +0100
Organization: AS2917.net
Message-ID: <012701c74de1$8f135e20$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <012001c74dde$87a16bd0$2101a8c0@donald>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdN3Sb0WA52hll5Ru6mIGWeM5Qj1QAARy2gAADMgWA=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Benoit, that was it ! Removing the entry in the iftab file
stopped the renaming of the interface !

Regards,
Paul

