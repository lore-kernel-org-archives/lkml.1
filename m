Return-Path: <linux-kernel-owner+w=401wt.eu-S965295AbXAYM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbXAYM4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 07:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965276AbXAYM4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 07:56:33 -0500
Received: from web7706.mail.in.yahoo.com ([202.86.4.44]:38402 "HELO
	web7706.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965295AbXAYM4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 07:56:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=NEvLCrSkBFnxwbJTp7+U0bsbDo+8TwNmIVkqiTBkL14E4eVEXYpPux+c/iOWjlB60l/gbXtAum2IwXkB1dfmXo0ogLQj3PMpL2tTvrqtJxt93KFgSH7/wo3jw53cNWapO4NhMuFnrkzhES3i8MpCWf0qM3vXSwMuv5FID5wQ4cQ=;
X-YMail-OSG: tmBiBgcVM1les9ItD_TxqReo_QERXW051nYYnDNFowD8Ss24YTPMkv22.sLXrq6KBJYnXs5QtI4Bihj4Lplvg1D.a7bh8KgFhJgJthaai8vf3wX6TKTt5fSEoATelVQ-
Date: Thu, 25 Jan 2007 12:56:30 +0000 (GMT)
From: Seetharam Dharmosoth <seetharam_kernel@yahoo.co.in>
Subject: que: How can we Eliminate the DMA Zone from the kernel?
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <161367.39134.qm@web7706.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Want to remove DMA zone the from the Linux Kernel.
(Don't want to use DMA Zone, because i am not
using ISA bus, am using PCI bus. So, I don't need
this)

Can you please give me suggestions in this regards.

Thanks
RAM




		
__________________________________________________________
Yahoo! India Answers: Share what you know. Learn something new
http://in.answers.yahoo.com/
