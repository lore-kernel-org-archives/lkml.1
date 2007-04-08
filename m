Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXDHOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXDHOg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXDHOg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 10:36:56 -0400
Received: from web86905.mail.ukl.yahoo.com ([217.12.13.57]:31941 "HELO
	web86905.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751243AbXDHOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 10:36:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=wckInUyN/jAph4Q2CAdD3/qzod6jvLGb/vGki5lV2+GKdbSygvBtZXnkpdGNX4gWm74BK59CNVVMy2zq/G3179Q7h5JZOOVPYV9f4lO8sWhK96g3w1F2xU3UjUDY5dUE0hY/MO23maT83/AeIo0EFneomXC6hTMoNK+z5fQZByk=  ;
Message-ID: <20070408143653.97346.qmail@web86905.mail.ukl.yahoo.com>
X-YMail-OSG: .vR2DWYVM1nuh263nXq11P2NPfIbCzNMqmiXwxlxIgF45bYicSPsZEexsajfq6bBkJDonV68a0TJ9wlL2viKltjnqjpaM8TvFw--
X-Mailer: YahooMailRC/478 YahooMailWebService/0.7.41.8
Date: Sun, 8 Apr 2007 14:36:53 +0000 (GMT)
From: JanuGerman <doublemalam@yahoo.co.uk>
Subject: Security computation within Linux kernel
To: linuxkernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi every one,

I have one question regarding security libraries, already shipped with Linux Kernel. That is, all PKI, RSA libraries, as provided by OpenSSL are already integrated within the linux kernel source code? OR, one have to use OpenSSL seperately in this regard. 

I can see, linux/crypto.h and linux/hash.h files shipped with 2.6 kernel and know that SHA1 "hashing" can be done using linux/hash.h, but beside that, any possiblity for RSA or PKI.

If yes, any link to their use, will be highly appreciated.


Best,
JG


		
___________________________________________________________ 
Copy addresses and emails from any email account to Yahoo! Mail - quick, easy and free. http://uk.docs.yahoo.com/trueswitch2.html
