Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZBXEz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZBXEz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZBXEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:55:20 -0500
Received: from web30104.mail.mud.yahoo.com ([209.191.69.36]:24094 "HELO
	web30104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751788AbZBXEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:55:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=eoMvM3DYyOGpwal2qJpFQ/m5/ZteZJjBDURdkZCzc1lr1TEgTEv9xdmNYHEt2Nli0hxcrBbue/XZl1sYjf21LMVUCGj3rpUbI8v2uJvEHjEnoMM1Ix2eci2AJ1jgy5M6jRqZbxKNSNja+sFyXNPsil+Xh91ddUeQdH78BfXZfK4=;
Message-ID: <389971.28411.qm@web30104.mail.mud.yahoo.com>
X-YMail-OSG: ZUOfYagVM1m38TsjPs9RLguhZYSYDYTeEgWFKA007TZoN6h6IHgQj_IhRu1yzXDgX_HrtNs.jWgWaWjuij_LtnBJsJ0xzWgn61otZ5e7poqfPZRTMzpMAUmOmcwnu9uGvMOjzXW5DvUNLAkLjVh3KYMViuDWHFqq6RVFEiB3imwPukJZalUveRRRym.d
X-Mailer: YahooMailClassic/5.1.18 YahooMailWebService/0.7.289.1
Date: Mon, 23 Feb 2009 20:55:17 -0800 (PST)
From: Parav Pandit <paravpandit@yahoo.com>
Subject: virtually and physically (page) aligned allocation
To: Linux kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Can user space application allocate memory which is virtually and physically aligned to the system's page boundary in the Linux 2.6.x?
Such as using posix_memalign().

In other way,
If user space application allocates memory which is aligned to page boundary for say 4 pages using posix_memalign(), will is ensure that it corresponds to exactly 4 physical pages in kernel which can be pinned down?

Regards,
Parav Pandit


      
