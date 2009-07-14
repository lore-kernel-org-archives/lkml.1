Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZGNKrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZGNKrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZGNKrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:47:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51996 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbZGNKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:47:15 -0400
X-Sasl-enc: Vedmr5Qt09KJo2zOgD+Kg7yG92HzaoZ3FOD8+EhHfsxs 1247568434
Date: Tue, 14 Jul 2009 07:47:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090714104712.GB19866@khazad-dum.debian.net>
References: <20090714092513.GB2010@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714092513.GB2010@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Pavel Machek wrote:
> Subject pretty much said it all. Normally, backlight level is kept from
> previous boot. ... which is unfortunately not the case with
> 2.6.31-rc2. Thinkpad x60.

What is controlling the backlight? ACPI video or thinkpad-acpi ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
