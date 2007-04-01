Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbXDAWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbXDAWqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 18:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXDAWqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 18:46:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32954 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbXDAWq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 18:46:28 -0400
X-Sasl-enc: ImXmwAqLyxfnhodKADivDcE5UQyYl/z5zg5MBVajANMx 1175467588
Date: Sun, 1 Apr 2007 19:46:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Message-ID: <20070401224625.GB28561@khazad-dum.debian.net>
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org> <20070401163204.GB5762@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401163204.GB5762@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2007, Pavel Machek wrote:
> ACPI is misdesigned, and lm_sensors can't cope with that.

Err, HOW exactly are you accessing the ThinkPad i2c buses directly? Or did
Lenovo change completely the hardware project of thinkpads in the X60?

Or did anyone add an lm-sensors that attach to the ACPI EC ports now?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
