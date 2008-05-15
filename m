Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYEOSnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYEOSnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbYEOSni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:43:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17245 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388AbYEOSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:43:37 -0400
Message-ID: <4076165.1210877010629.JavaMail.oracle@acsmt302.oracle.com>
Date: Thu, 15 May 2008 13:43:30 -0500 (CDT)
From: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
To: rdreier@ciscom.com
Subject: next-20080515 IB warnings
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


on x86_64:

next-20080515/drivers/infiniband/hw/ipath/ipath_sdma.c:348: warning: format '%016llx' expects type 'long long unsigned int', but argument  3 has type 'long unsigned int'
next-20080515/drivers/infiniband/hw/ipath/ipath_sdma.c:618: warning: format '%016llx' expects type 'long long unsigned int', but argument  3 has type 'long unsigned int'


---
~Randy

