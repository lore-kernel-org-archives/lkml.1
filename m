Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYHNFlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYHNFlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 01:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYHNFlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 01:41:12 -0400
Received: from n3a.bullet.mail.ac4.yahoo.com ([76.13.13.66]:24927 "HELO
	n3a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750748AbYHNFlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 01:41:11 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 01:41:11 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 703600.46542.bm@omp104.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=p+kBJZZXfkAnhK13L9BYi2oDtiyuEd0Y2CV3eDMNM1QbUrxVyaLoqDVDlXOw/ZdU0e/w7v07qVuAoWjo5uAQh2hGOs9UpAee3VbNdXThIFZtELdesh7z5zJre/l7uhYon9BuUYJ0ZlyXdS7ZZYhQ0xr4kh0HFIronqot+NAwEHA=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 13 Aug 2008 22:35:27 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: KGDB kernel panic no init found in linux 2.6.26 after booting KGDB enabled
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Will Newton <will.newton@imgtec.com>,
       linux-usb@vger.kernel.org, leoli@freescale.com,
       Will Newton <will.newton@gmail.com>
In-Reply-To: <1218551957-17091-12-git-send-email-will.newton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <988856.23455.qm@web45214.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
All
I am configuring linux 2.6.26 kernel in laptop and transferring image to desktop.
My desktop is IDE drive. I am getting kernel panic try init= option error after booting the kernel. 
I am trying to setup KGDB on linux 2.6.26 kernel between dev machine and test machine. I have issues and it is not working.
I can get the kgdb to communicate but I cannot start init images to start. I am using Redhat grub configuration.
Do we need apply any patch for 2.6.26 kernel. I am using 2.4.15.5-kgdb patch. I can get communication to work after applying patches. 
The system gets into kernel panic after the connection is made because of corrupted initram image.
Can anybody  please give me sample grub entry so that I can try.
Should we use init-2.6-kgdb.img or not. If yes how to create it, what about modules in /lib/modules/2.6.../
Can you please let me know how to fix this issue.
After KGDB is enabled the kernel gets into panic mode otherwise it works fine.Can anybody please let me know why KGDB crashes the system. 
 
Thanks
Amruth p.v





      

