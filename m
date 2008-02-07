Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbYBGUhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbYBGUhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbYBGUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:37:28 -0500
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:38995 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756268AbYBGUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:37:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=WN6DwKNw4jjidtKRWEzR7zcMKhrsdrjw2chkw0OZ43cZ+ei+TCk6VzFlt1T3/sopJLpQmNqmou89kQ5yFvb9uHi5d0+2sFzxFdQt+uzDAnpcNSwrclUwAJVnE/PlXDTmnu0KXZj7oC0nzNwIGvMi9pJ9YhuUBdnr/z4OiIQrp8I=;
X-YMail-OSG: ZhVpMSEVM1ltoll__A..0s0oPOMONMY_veuFZVjPKYe.uc7DsSeG7EleRwodhlqpL6urQw--
X-Mailer: YahooMailWebService/0.7.162
Date: Thu, 7 Feb 2008 12:37:22 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
To: Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ming Zhang <blackmagic02881@gmail.com>
In-Reply-To: <1202398695.1805.48.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there an open iSCSI Target implementation which does NOT
issue commands to sub-target devices via the SCSI mid-layer, but
bypasses it completely?

   Luben

