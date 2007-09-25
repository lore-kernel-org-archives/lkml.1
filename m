Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXIYIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXIYIjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXIYIjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:39:01 -0400
Received: from web51407.mail.re2.yahoo.com ([206.190.38.186]:24998 "HELO
	web51407.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755506AbXIYIjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:39:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jPIZL2FgvZ/sR0e0UvY4s6rfo6kBmgn+Dax1Y5Q3eLV+mYmzzAzEv7U7pXTUkJ8j8TocyJ8T3smVM4XrtcHoqK3KBKgtDOIU8Hi7QCwazagXce4W1VfLAs7UAp1Vr3i92fMfzW5S5CEjo3fiHmWZTGdMTVNSybyDb+WPexY1NNo=;
X-YMail-OSG: cXXA5bAVM1krJhBT6pze4by73MTPSL1mMAklcK7oZ3ul_7f8kTzjlDTfu5m1SKEdvYKulvmulkOJB_akiVqB31X9BR4Qk5NahyxfPblKff4q9DKmprYjvlsligAEmCZfLcZPl.elLxOrJbYb4X6avqbS3w--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 25 Sep 2007 01:38:59 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: RE: Problems with 2.6.23-rc6 on AMD Geode LX800
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <267869.77756.qm@web51407.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck, Jordan,
thanks for taking an interest in this problem. As suggested by Jordan I tried a new
BIOS revision from
http://www.digitallogic.ch/index.php?id=256&dir=/MSEP800%20-%20SM800PCX%20%20-%20MPC20%20-%20MPC21&mountpoint=23

Unfortunately the kernel still fails to boot in the same way.

Do you still need the disassembled reserve_bootmem_core? 
--  
Thanks and kind regards
 Joerg



      ________ 
Yahoo! Clever: Stellen Sie Fragen und finden Sie Antworten. Teilen Sie Ihr Wissen. www.yahoo.de/clever

