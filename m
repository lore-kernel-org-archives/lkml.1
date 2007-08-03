Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXHCJgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXHCJgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 05:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbXHCJg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 05:36:26 -0400
Received: from web26903.mail.ukl.yahoo.com ([217.146.176.92]:36040 "HELO
	web26903.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757720AbXHCJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 05:36:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=y1GkShfUvWgURkPRDLjZZSyv+vxoTWsW5taZkXD3QX6wfoQw5cAMZI7DNMj7F2dM/u0W8FPNYVVrMOTRniVBtttWhwldf06DYhowQm69ACPDObTvSvWV3s4OegwJt8K5QE4L91fo93iNt7TG4KXabrGFPFQLhy8ZK6cBMUoedzE=;
X-YMail-OSG: dyQI5eEVM1nHVa3Uvpyd.6EtmQjzszJqoME6lT_iTU56sPuRgwgTD79dE64lmAK9TxAb7xaUzQ--
Date: Fri, 3 Aug 2007 11:36:24 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Complete freeze if high traffic on standard serial line on ia32?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <465648.43203.qm@web26903.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 I can reliably (6 times in one hour) freeze completely (Scroll lock/Caps lock
flashing together, mouse frozen in X) my PC (AMD sempron on MSI K8MM3-V K8M800
Socket 754) by doing an FTP using a standard modem connected on the serial port
of the motherboard, and a bit of browsing (i.e. machine not loaded).
 That happens on standard Fedora 7 kernel and on the latest 23-rc1 kernel, and
doesn't happen on a Puppy Linux 2.17 bootable CDROM.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
