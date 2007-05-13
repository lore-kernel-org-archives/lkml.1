Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbXEMXiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbXEMXiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbXEMXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:38:39 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:63602 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbXEMXij convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:38:39 -0400
Date: Mon, 14 May 2007 00:38:31 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: New version of shutdown?
Message-ID: <20070513233831.GA30072@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 I've just shut down -rc1 on my ppc64, and got a big scary message
from the following code in libata-scsi.c:

ata_dev_printk(qc->dev, KERN_WARNING,
	"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
	"UPDATE SHUTDOWN UTILITY\n");

 So, I went to http://linux-ata.org/shutdown.html, but as far as I
can make out, every distro is expected to reinvent the wheel by
altering shutdown themselves.  For those of us who build from
source, (e.g sysvinit-2.86) is there an example of an up-to-date
released version of shutdown ?

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
