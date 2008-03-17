Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYCQLHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYCQLHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 07:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYCQLHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 07:07:40 -0400
Received: from web95111.mail.in2.yahoo.com ([203.104.18.163]:43253 "HELO
	web95111.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751874AbYCQLHj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:07:39 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 07:07:38 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zVU/t9l5lUalhyd/aBLWhlJKaqNoJ0hIX9fbz+20u0r8pqCw66JvcCs1iDFrTB71Q+/rpp8HAD966cd1o1HS/SL4XTOOmeiwCMyBhnVeSB30D6eixGUIiOp7WQuOws4TEl+oYOsDNTpX0UdwDEym/xK4/uigtj5TO6S6rruIugg=;
X-YMail-OSG: evGIINUVM1lRScbxW4mDTIdYp34n3W9X64dAF5fP31KCoenjmWKQXxynuXvvcXojPG5fTU_905pUXkRBzu_JaRxMhEniqTtfkj.e8JmXBSyrPo4SRBT94GHXFzWAWQ--
X-Mailer: YahooMailRC/902.38 YahooMailWebService/0.7.162
Date: Mon, 17 Mar 2008 16:30:56 +0530 (IST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: ip_rcv, ip_output  is not exported in 2.6 kernel.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <675935.47325.qm@web95111.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
 
         Can any one tell me why ip_rcv, ip_output is not exported in 2.6 kernel.
         If I have to use this function in kernel module what should be the approach.
         Do I need to export it, in kernel code or there is any other alternative.

Thanks
Murtuja Bharmal


      Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups
