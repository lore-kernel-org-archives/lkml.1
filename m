Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZFYOP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZFYOP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZFYOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:15:14 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:32891 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZFYOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:15:13 -0400
X-Greylist: delayed 5902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 10:15:12 EDT
Date: Thu, 25 Jun 2009 14:24:14 +0200
From: Daniele Venzano <venza@brownhat.org>
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
       Michael Chan <mchan@broadcom.com>,
       Eilon Greenstein <eilong@broadcom.com>, Divy Le Ray <divy@chelsio.com>,
       Samuel Ortiz <samuel@sortiz.org>, Tim Hockin <thockin@hockin.org>,
       Jens Osterkamp <jens@de.ibm.com>,
       Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
       Ion Badulescu <ionut@cs.columbia.edu>,
       Andy Gospodarek <andy@greyhouse.net>,
       Alexander Indenbaum <baum@tehutinetworks.net>,
       Samuel Chessman <chessman@tux.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Grant Grundler <grundler@parisc-linux.org>,
       David Dillow <dave@thedillows.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/19] drivers/net: Use PCI_VDEVICE
Message-ID: <1245932654-424f6eb9656d75bc862590453a717473@brownhat.org>
X-Mailer: Infomaniak Webmail
X-Origin-IP: 85.36.125.250
MIME-Version: 1.0
X-Priority: 3 (Normal)
In-Reply-To: <f746d5c571120f930fb6bb50d8303766573f927d.1245906152.git.joe@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Message d'origine -----
De: Joe Perches <joe@perches.com>
Date: Wed, 24 Jun 2009 22:13:28 -0700
Sujet: [PATCH 12/19] drivers/net: Use PCI_VDEVICE

> drivers/net/sis900.c              |    6 +--

sis900 changes ok.

Acked-by: Daniele Venzano <venza@brownhat.org>

--
Daniele Venzano
venza@brownhat.org
http://www.brownhat.org
