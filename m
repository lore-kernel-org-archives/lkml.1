Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYFFLh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYFFLh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYFFLhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:37:50 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:59786 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYFFLht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:37:49 -0400
Message-ID: <4849213A.4080001@cetrtapot.si>
Date: Fri, 06 Jun 2008 13:36:26 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: dev-etrax@axis.com
Subject: [PATCH 2.6.26-rc5 0/2] cris: compile fixes for 2.6.26-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current status of cris architecture is that current GIT tree at 2.6.26-rc5 does
not even compile.

To remedy this I've created two patches that are sent as a reply to this post:
1. add dummy ops for serial debug port
2. make compile succeed when building with O= (srctree != objtree)

Best regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si




