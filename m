Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbYLHJAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbYLHJAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYLHJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:00:24 -0500
Received: from web15705.mail.cnb.yahoo.com ([202.165.102.72]:22535 "HELO
	web15705.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750707AbYLHJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:00:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=0JTj21RPqvMuwDC7kfp/L8NWmoMui5G0Dk+ca96Xpy0bKDnMLpflDmMGq4C2/RIe4Fs5v37iVDgra9JYFRLh0oq2jLkC7pq0/nFoipVffyI2rKut1gDyZ5XgUUoeaGcyDjQP5MXJ9Hcdqk02c31DG4MNtMFg3A9/6DTsl+1wTRc=;
X-YMail-OSG: uFRBnqkVM1l1S_gc3gDRiwwAmuSQdVjTxAK3NZaVrqaOvsUZ8Dk7jk7X5CcX93DAIjAIHWZGXCzZyo8Jk1_g0cqDY79iNFJ657hdZEXSNMST5pbtxb9wbTchWhoOxTuu2qPa1RHxEiDLsBNLD0gzEQcGZ_pFpQ.d3ctYudhCn09a6EY-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Mon, 8 Dec 2008 17:00:20 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: question about the size of zImage
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <487368.30651.qm@web15705.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

I got the information that the maximum kernel size after decompression
is 4M . from  http://www.simtec.co.uk/products/SWLINUX/files/booting_article.html#d0e416
I knew this information is incorrect in new kernel .

I get the info is the maximum kernel size after decompression is  4x zImage from linux/arch/arm/boot/compressed/head.S .
 
1. I want to know whether all architecture has similar soft-limit or hard-limit ?
2. Does kernel has hard-limit size of kernel ? 

Thanks Advanced 
Best Regards.
Peter Meng


      
