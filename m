Return-Path: <linux-kernel-owner+w=401wt.eu-S1750910AbXBJQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbXBJQjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 11:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXBJQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 11:39:51 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57375 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbXBJQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 11:39:50 -0500
X-Sasl-enc: CouULKtzxvBm893pCtsUf0NxQB/6Fz3dJa8EUsdLB+Q9 1171125587
Date: Sat, 10 Feb 2007 14:39:27 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Message-ID: <20070210163927.GA489@khazad-dum.debian.net>
References: <200702071418.51058.lenb@kernel.org> <200702101027.25372.ismail@pardus.org.tr> <20070210120713.GA31473@homac2> <200702101752.14797.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702101752.14797.ismail@pardus.org.tr>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Ismail Dönmez wrote:
> Hmmf looks like a userspace bug, but it certainly did work before ACPI update.

Well, I don't know if this is the case here, but after reading the userland
code that people use on most applets to read /proc/acpi/ibm, I was upset and
disgusted for days.

Some userland code *deserves* to be broken with extreme prejudice.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
