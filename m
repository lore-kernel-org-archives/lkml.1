Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbYFDT0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbYFDT0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761970AbYFDTZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:25:51 -0400
Received: from web95112.mail.in2.yahoo.com ([203.104.18.164]:23808 "HELO
	web95112.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760288AbYFDTZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:25:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xp9FhQgpvhG7UY4170OfZxg6+rlPgJMah2yvpYL8hqJaVvnmfoeUkCe4d3kwnNte+1wHHbvuOvh1QOIDium36wOrBArLSPHrOm4Ph07BPCcHK11qFb/1tExlchzhbzF/1IUpW9Pjce5yazW2y3dIQtY1hSD+HCljRIG0yhIXGH4=;
X-Mailer: YahooMailRC/975.41 YahooMailWebService/0.7.199
Date: Thu, 5 Jun 2008 00:55:46 +0530 (IST)
From: murtuja bharmal <murtuja_bharmal@yahoo.com>
Subject: inter_module_register substitute in 2.6 kernel
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <911711.26477.qm@web95112.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Is there any substitue of inter_module_register, inter_module_unregister, inter_module_put and inter_module_get_request  functions in 2.6 or only we can implement it through EXPORT_SYMBOL.
I am little bit confuse about functionality of above function in 2.4.
In 2.4 all symbols inside the module is publicly exported by default still there is functionality like inter_module_xxx.
what is differenct between inter_module_xxx and EXPORT_SYMBOL and why it is deprecated in 2.6.
Murtuja 


      Bring your gang together. Do your thing. Find your favourite Yahoo! group at http://in.promos.yahoo.com/groups/
