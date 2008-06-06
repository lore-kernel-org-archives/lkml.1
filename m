Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYFFFFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYFFFFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 01:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYFFFFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 01:05:10 -0400
Received: from web32404.mail.mud.yahoo.com ([68.142.207.197]:21472 "HELO
	web32404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751618AbYFFFFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 01:05:09 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 01:05:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=6qvZOlN/Gei46NEo/FU24YrtyUatQnvkQrgAoArAiqiRlECI0TWh9wyGyNsUZ2o+hPH0goFq5MAaQplxGEy0XNIXxagGDXo+tvnANGlecQ0IjXM/Tc3PbVlcwsF6lFD7z/D6wY1x5J+jrKO1Wx28ks9CjZB0q8uoZwNF/Wi9b50=;
X-Mailer: YahooMailWebService/0.7.199
Date: Thu, 5 Jun 2008 21:58:28 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: blk_queue_hardsect_size 520-byte sector
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <339116.28290.qm@web32404.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can I call blk_queue_hardsect_size in a driver and set it to 520-byte as hardware sector size. 
How does the kernel and block layers take the request, will it be in multiples of 520-bytes aligned or 512 bytes aligned?

Thanks for your help in advance.

with regards,
  Anil


      
