Return-Path: <linux-kernel-owner+w=401wt.eu-S1767549AbXCIV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767549AbXCIV2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767550AbXCIV2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:28:30 -0500
Received: from web55605.mail.re4.yahoo.com ([206.190.58.229]:27576 "HELO
	web55605.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767549AbXCIV23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:28:29 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 16:28:29 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Oejifsbwm12iD9zp/nllHIy2RccxVu81kKUpBM3mgon0o/uO09nzZCjcDBsY8AjHD0jhA8Hru11K9thyGK4I3DCfGswjCT4JefB9u7SO5A52z9JMsA+PRq4PkBWu6Ypr0cKkjxhwVX6rdgTpdMU/O6Li+v7wgFqlpCoz6ew/aEc=;
X-YMail-OSG: 9MgZh3MVM1lGM.Ij2c75hqvNF_GD.jF_MeG2ZPStVZ9hXhsRJmhDAVuoijM0imYJuvHxqigNhGPoy_Yl5ta2COzEt4MMqdX6Wo6eW6zNHttkQRCnjNHEKAENAVDohZzKHQrCrJKGTPlxRVg18.6OhKqy
Date: Fri, 9 Mar 2007 13:21:48 -0800 (PST)
From: Amit Choudhary <amit2030@yahoo.com>
Subject: getting memory for a limited time.
To: Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <595070.37181.qm@web55605.mail.re4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any debug option where I get some memory (from kmalloc() family) for limited time only.
Once the time slice expires, that memory is zeroed out so that if I use it again after the time
slice expired, I should see a crash.

-Amit


 
____________________________________________________________________________________
Finding fabulous fares is fun.  
Let Yahoo! FareChase search your favorite travel sites to find flight and hotel bargains.
http://farechase.yahoo.com/promo-generic-14795097
