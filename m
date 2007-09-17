Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbXIQJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbXIQJ7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXIQJ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:59:29 -0400
Received: from goblin.aladdin.com ([192.118.129.192]:33312 "HELO
	Goblin.aladdin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752786AbXIQJ72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:59:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: kernel thread id 
Date: Mon, 17 Sep 2007 11:59:26 +0200
Message-ID: <C4A438513D3F12459455E5D43FD54783017F780C@extlv102.eAladdin.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel thread id 
Thread-Index: Acf5EWtJe2OUdwU2TXWuSJBKnKlRVA==
From: "Yishai Hadas" <Yishai.Hadas@aladdin.com>
To: <linux-kernel@vger.kernel.org>
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

I'm using NPTL multi-threaded library and kernel 2.4.

When a new thread is created using the pthread_create call the returned
thread handle is pthread_t.

I want to get the kernel thread id for this pthread - means similar to
what gettid returns when it's called by the thread itself.

How can achieve this information from the creator thread?



Any help is appreciated.

Yishai.

**********************************************************************************************

The contents of this email and any attachments are confidential.
It is intended for the named recipient(s) only.
If you have received this email in error please notify the system manager or  the 
sender immediately and do not disclose the contents to anyone or make copies.
** eSafe scanned this email for viruses, vandals and malicious content **

**********************************************************************************************

