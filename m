Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXHCNV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXHCNV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 09:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbXHCNVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 09:21:20 -0400
Received: from web26912.mail.ukl.yahoo.com ([217.146.177.79]:44195 "HELO
	web26912.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757358AbXHCNVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 09:21:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JZzheBeUOKE/oJpmbL4IVHNCtYquGQoiYAO3XQKTk1pHfGY7e1okvYcDZb2Esx1UR5Yu7cUyH+KFuAFDmtGnsyZK5eg+bMVm4JzsFKjkUacgTB3L1n33bL5q+4A8yCz3k/2dLeCOn3uF71MWZ6RqrXr7n21Hwe1T8pvMGG8QbL0=;
X-YMail-OSG: 8IV8D_wVM1mjGe32xsNnMSe8wsXx0YPm_DZq_tmkwkArNNx1it1trgwyE8m8aUfDrQ--
Date: Fri, 3 Aug 2007 15:21:18 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: RE : Complete freeze if high traffic on standard serial line on ia32?
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070803141347.19136546@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <296947.87528.qm@web26912.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Can you get this to happen outside of X at all (eg if you do a yum update
> and pull in packages over the modem for a while with 2.6.23-rc1  does it
> die). Just trying to work out what has become unstable.

 I'll try more stuff tonight. A wild guess of the problem would be the amount
of interrupts from the serial port (I was sending if that matters).
 I never seen the problem without the modem connection, this PC is stable
for ia32/ia64 for few months.

> Also worth trying to see if browsing web type stuff off a CD or local
> files triggers it without the network link.

 Browsing alone over the modem did not seem to trigger the problem, but
I will do more tests with/without X/browser and ia32/ia64 tonight.

 Etienne.



      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
