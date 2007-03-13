Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXCMHvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXCMHvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXCMHvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:51:21 -0400
Received: from web86912.mail.ukl.yahoo.com ([217.146.177.84]:32367 "HELO
	web86912.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753182AbXCMHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:51:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 03:51:20 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=o/vSMp1q2InsOeCuKt6FkSd16oMdAWLQq/8YJ3YeqjSNEdxguBVN++2mQhz7PxIeX1CRpE93xZsgH0lzgdmi1SSI6pwBplPzM751/LVqCxuTaqhXUnU4g1jlQkhakMp35KdN5wqxA/+A5XNfDVa1/2mKSM0LfrdeuZ//9km7kKo=  ;
Message-ID: <20070313074439.22410.qmail@web86912.mail.ukl.yahoo.com>
X-YMail-OSG: 7An7MKQVM1lBVjR6k6ZawigTVvjZipb3Dw3hL2TTA7OMT46w9s9AmoYTi9DsKBvzzN8UMApeE_PCWLCyXk5lIJkEP9Ka.PHzpFEMqeKruV5qtk7Mt2xrIfAhHjVbUnhZEi9JpN9GZRBq1ebTA67NEnw-
Date: Tue, 13 Mar 2007 07:44:39 +0000 (GMT)
From: JanuGerman <doublemalam@yahoo.co.uk>
Subject: LSM Stacking
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Within the security folder in the kernel tree, the
2.6.20 linux kernel distribution is shipped with a
file root_plug.c (written by Greg Kroah-Hartman),
which is a classic introduction to Linux Security
Modules (LSM). The folder also contains the folder of
SELinux.

My question is that whether root_plug.c security
module is stacked with the SELinux security module or
not. If root_plug.c is stacked, where i can find the
code which handles the stacking of SELinux and
root_plug.c within the kernel.

Further, any pointer to stacking mechansims in Linux
2.6.* kernel will be highly appreciated.

Thanking you in advance,
MA





		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
