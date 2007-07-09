Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbXGINbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbXGINbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbXGINa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:30:58 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:50461 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbXGINa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:30:58 -0400
Date: Mon, 09 Jul 2007 15:30:56 +0200
Message-Id: <1986830882@web.de>
MIME-Version: 1.0
From: elvis_the_king@web.de
To: linux-kernel@vger.kernel.org
Subject: x86 vs x86-64 IO-related performance questions
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18G1tgyPbDkdQEf5jZolivXxArK45EZiFT/9eFZhMfTWsRPn
 ncGXO7iJx2gWiz5ZOsmPoFrmln5YqHjtTDaP7doAAjIoVux6R/F4MgXt4skB
 g==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

two questions I simply cannot find answered. On a EM64T capable machine with > 4GB RAM:

1. Should using x86 vs. x86-64 make a difference for block device IO, because more data can be carried at a time?
2. I can use the RAM through PAE, but single processes are limited to a 4GB virtual address space. Now can the kernel itself use more than 4GB at once for the buffer cache?

Thanks!
Matthias
_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

