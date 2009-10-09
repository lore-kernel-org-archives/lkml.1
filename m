Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbZJIThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbZJIThW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761331AbZJIThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:37:21 -0400
Received: from web53206.mail.re2.yahoo.com ([206.190.49.76]:36799 "HELO
	web53206.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761318AbZJIThU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:37:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zU0X8j+KR69AppRvXzeCC3sk6M4bhNhQ6gEGUyTeN6YaKLB3OHdFtKCiH6SBavbk8AoCYMgZTAw41zlVQ5DuKaGgIQGL44cyPdaCHlRpwtarRdDMD4ZcSrG8RZChgSV7udXoWnrH8TderZ87xwkXG2lxb9LivLAPDV/MQoTLYZ0=;
Message-ID: <840534.40534.qm@web53206.mail.re2.yahoo.com>
X-YMail-OSG: wLxV7HIVM1nCzro5D.FuJqQKklsoRzR4M2dtGms.kRSc_6QLTp_G_pJmXYeTcov6VR2iByBsaat6bT2LzYqTtzPW6IN3vCzXvmthfzrnIa6ikQILKMOpw6N.DzgP4vTvUaHv4c9XKNO8TzhPHbNH.Tblym.CpzCrP3i2bdW2UJR5_ipFZ6CSMKTkrMGkg4AZrPqUhI3ZUG7pHYvTRlcwVN6m9EMx8D5UxgwbWEvEWua4VMy6S.8EWBBZvroiGoQPIEd1mX5wTBdvfIAjqXiL0uHMRkQJnkrAQwa.XGzIyD4nOZM1N7mt_4J9EbltaA1svbTXLsXcDVyXDxF8ZF5KwdcmRhyWDaUwlExMpHbXNQSHkb6u1.66Hs0O0YEW8PvO8WCnbHNwcvVXNMkqBBb3xNmySJTxtWpxj4En8wj_8FvF4vF2bt_ifBiMmoIzecpTb1jasg--
X-Mailer: YahooMailRC/182.10 YahooMailWebService/0.7.347.3
Date: Fri, 9 Oct 2009 12:36:38 -0700 (PDT)
From: Reza Salehi <rezsalehi@yahoo.com>
Subject: Question about "scheduling while atomic"
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am wonder where I can post my general questions for help about kernel oopps ?

I am getting kernel oops "  scheduling while atomic: watchdog or swapper" it doesn't make kernel to crash but i am sure it is not a good sign..
I am not holding any spin lock at all.
I am wonder what would be the right approch to debug this issue. I am using kernel 2.6.28 on MIPS procesor. 

Thanks for your help in advance. 

Best Regards,
Reza

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
