Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXCBNrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXCBNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992442AbXCBNrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:47:10 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35431 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992439AbXCBNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:47:08 -0500
X-Sasl-enc: lfZi96egCL+G/swu2TwReNv5JZSZIE+wiIyFBOhCLQyp 1172843228
Date: Fri, 2 Mar 2007 10:47:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Rudolf@ATrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-ID: <20070302134703.GB23656@khazad-dum.debian.net>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070301174806.GA4979@redhat.com> <20070302122736.f14a7a22.khali@linux-fr.org> <20070302113158.GC2156@elf.ucw.cz> <20070302143720.cfd8afeb.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302143720.cfd8afeb.khali@linux-fr.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007, Jean Delvare wrote:
> (And as a side note, this is really the board's owner SMBus controller.
> The hardware doesn't belong to the BIOS author.)

Especially when they won't do their job right, and won't fix it later
either...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
