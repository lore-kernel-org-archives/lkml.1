Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYJNWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYJNWzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYJNWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:55:27 -0400
Received: from web32406.mail.mud.yahoo.com ([68.142.207.199]:43059 "HELO
	web32406.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750954AbYJNWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:55:26 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 18:55:26 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=PEcMR54kUTIT5XRR+hw98PDwR2RSQO0Ga7oW93MMa5shi8Jx4domxQzkevIRac/w5cSvZH/w0pbhDXLCpfyrxEpzyRp9qxeTZ1kSAgr7zuUW35TmdpEnZo0UengD3yMQT4pczyVk4ArgnFHBYf0OaV6ily8Pcqskiryj0H5OWXU=;
X-YMail-OSG: HCZ9BYAVM1k7WZHjauTmfuvLq.axXKxCuEcgnERgVHONUXB6wQnEbOi._7mmiyn4VLj6b0AEL4xYou3_MhPh3.ZSMtZqy8J9B7d23LWzN3z38q7e8STO1JHq9TpbEXPVsm0TRo39w1.mqxrhHtW3bbeHQndR7eI.ZRUj.J8-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Tue, 14 Oct 2008 15:48:46 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: kgdb for 2.6.26
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <444546.96900.qm@web32406.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found that kgdb is now able in kernel 2.6.26. Is there any other patch I need to have kgdb up and running for this kernel like 8250.patch, i386.patch along with this. If so, can you please point me to the location to pick it for this kernel.

with regards,
  Anil


      
