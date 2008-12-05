Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYLEWWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYLEWWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYLEWWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:22:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:21345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYLEWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=adrmZCrQM23UGKrcAf7qBXiY+NFGNade95HVubSJ0YCwscSa7zJ6FazpShxlzQuLbe
         b1NFzPdtvTL2mHdT4cYETfUXo9LeRB1yfOeznvtad406+wT4PqWJU1sH5q8VHNdFfs6K
         cS+B1bF+UOn77bl734i1vmI3zUlNHpPpfqzA4=
Date: Sat, 6 Dec 2008 03:51:54 +0530
From: Balaji Rao <balajirrao@gmail.com>
To: ben@simtec.co.uk
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [trivial] Fix typo
Message-ID: <20081205222154.GA24294@cff.thadambail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Fix typo in license string.
    
    Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/drivers/serial/s3c2440.c b/drivers/serial/s3c2440.c
index 317d239..29cbb0a 100644
--- a/drivers/serial/s3c2440.c
+++ b/drivers/serial/s3c2440.c
@@ -177,5 +177,5 @@ module_exit(s3c2440_serial_exit);
 
 MODULE_DESCRIPTION("Samsung S3C2440,S3C2442 SoC Serial port driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPLi v2");
+MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:s3c2440-uart");
