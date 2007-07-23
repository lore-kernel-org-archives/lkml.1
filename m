Return-Path: <linux-kernel-owner+w=401wt.eu-S1764239AbXGWKRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764239AbXGWKRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXGWKRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:17:02 -0400
Received: from wizball.ivistar.de ([62.8.195.161]:43865 "EHLO
	wizball.ivistar.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXGWKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:17:00 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 06:17:00 EDT
From: Andreas Micklei <andreas.micklei@ivistar.de>
Organization: IVISTAR AG
To: linux1394-devel@lists.sourceforge.net,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Date: Mon, 23 Jul 2007 11:58:09 +0200
User-Agent: KMail/1.9.7
Cc: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       linux-kernel@vger.kernel.org
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <200707231007.50565.andreas.messer@stud-mail.uni-wuerzburg.de>
In-Reply-To: <200707231007.50565.andreas.messer@stud-mail.uni-wuerzburg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231158.10585.andreas.micklei@ivistar.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 23. Juli 2007 schrieb Andreas Messer:
> The first System, where harddisc don't work at all with the new stack:
> Nvidia NForce2 Ultra Chipset; 1GB RAM; XP-M 2600; FW-Controller is
> PCI addon card; lspci says Via

Additional note: On the machine where my iPod 3G corruption occure I have a 
VIA K8T800 chipset, but I have also an Athlon (Athlon64 3200+) and a VIA 
IEEE1394 host controller.

regards,
Andreas Micklei

-- 
Andreas Micklei
IVISTAR Kommunikationssysteme AG
Ehrenbergstr. 19 / 10245 Berlin, Germany
http://www.ivistar.de

Handelsregister: Berlin Charlottenburg HRB 75173
Umsatzsteuer-ID: DE207795030
Vorstand: Dr.-Ing. Dirk Elias
Aufsichtsratsvorsitz: Dipl.-Betriebsw. Frank Bindel
