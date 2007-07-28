Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXG1FAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXG1FAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbXG1FA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:00:28 -0400
Received: from web58114.mail.re3.yahoo.com ([68.142.236.137]:46967 "HELO
	web58114.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751124AbXG1FA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:00:27 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 01:00:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=vDcj+dRWy2TonJy4woJD4EH4/1EbY0ySf5YL9uapFAcfk63E/6SUoJ3IAzWb7IwfyV6yCDB604jX57jkv0zGzEKBrk9wqb12fIREgmxp4B6lLXEXJUj3zp1sla2jTu6IS6nBckdw6RloQKX2q6I1wFRa3mp0JlHL8nQzrUlarnw=;
X-YMail-OSG: Gbb7cawVM1mcmP7SFTIfoAPzg8BA4YXb.9Y27Roph1oEZJketUVRuRR0zJMBc166AVAEjJsjl5MlP8vDjQiKlZo9mtO_39lBX_768KXxq1erE5SuPNcYL4qr67d.fkY-
Date: Fri, 27 Jul 2007 21:53:46 -0700 (PDT)
From: Craig Block <chblock3@yahoo.com>
Subject: IRQ Delivery Problem for MCP65
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <151241.60877.qm@web58114.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having trouble getting Linux to see any hard drives on an ASUS M2N-X
motherboard with an MCP65 (nForce 520) chipset.  When the kernel probes the
AHCI controllers, it hangs for a minute or so on each one and returns the
following;

ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)

Thanks in advance for any help you can lend,

  - Craig


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
