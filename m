Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbXGQMTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbXGQMTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXGQMTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:19:41 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:6537 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXGQMTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:19:40 -0400
Message-Id: <20070717121747.591687140@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jul 2007 14:17:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/8] s390 update.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The second s390 patchset for 2.6.23. This one contains bug fixes as
usual and one new feature: the z/VM unit record device driver (vmur).
This driver allows to access the virtual reader, punch and printer
when running under z/VM. This is useful, e.g. to access the spool
file containing a dump of the system generated with vmdump, or to
set up a bootable system in the reader.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

