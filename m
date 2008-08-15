Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYHOCqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYHOCqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYHOCq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:46:27 -0400
Received: from n1b.bullet.mail.ac4.yahoo.com ([76.13.13.71]:21064 "HELO
	n1b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752347AbYHOCq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:46:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 754462.88637.bm@omp101.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=UYcIB9hWPr4oERVN2WuwdfdroRJGb6++mkW/Pn8NUCr/ukMiciNMoox3946l8nUAzQOJPnUm5k4wyUwRsUqReZ7ZRdUlGUlSugj2rn28jEb+hB6aJj/6S+cnLJAsGvSkDodIL+z8jBGJDnQA3gZrwMP8poY0AXyh32fdaoYzzbY=;
X-Mailer: YahooMailWebService/0.7.218
Date: Thu, 14 Aug 2008 19:46:24 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: KGDB 2..26 fails to wait while booting
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <903878.21411.qm@web45204.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi
I have created 2.6.26 kernel with KGDB enabled but the system fails to wait. Can anybody provide me detailed info on how to setup the grub configuration to wait until gdb connects from development machine. 
Thanks
Amruth p.v


      

