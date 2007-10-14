Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbXJNEPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbXJNEPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 00:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXJNEPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 00:15:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40884 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXJNEPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 00:15:24 -0400
Date: Sat, 13 Oct 2007 22:13:21 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/2] Compile error fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, paulus@ozlabs.org
Message-id: <20071014040705.17867.42969.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here are two fixes which should go in immediately.  The first is change
to lite5200 which got lost when it was merged.  The second is a
brown-paper-bag typo.

Cheers,
g.

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
