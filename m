Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbXECGdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbXECGdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXECGdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:33:08 -0400
Received: from mail34.syd.optusnet.com.au ([211.29.133.218]:53269 "EHLO
	mail34.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbXECGdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:33:07 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Staircase Deadline cpu scheduler version 0.48
Date: Thu, 3 May 2007 16:30:24 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705031630.24913.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've done some minor cleanups and microoptimisations to the code since version 
0.46 in preparation for releasing -ck with SD as its base.

http://www.kernel.org/pub/linux/kernel/people/ck/patches/staircase-deadline/2.6.21/2.6.21-sd-0.48.patch

-- 
-ck
