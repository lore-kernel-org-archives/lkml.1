Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbXFBDYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbXFBDYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 23:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXFBDYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 23:24:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42065 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbXFBDYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 23:24:04 -0400
X-Sasl-enc: W+j8dBubg/DeA2qdKicjGbU3hpQ62XoPqIHwXB2LSqCH 1180754641
Date: Sat, 2 Jun 2007 00:23:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tuncer Ayaz <tuncer.ayaz@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.22 libata spindown
Message-ID: <20070602032358.GA8815@khazad-dum.debian.net>
References: <4ac8254d0706011314g5468f02m3cf5a5281bd30018@mail.gmail.com> <4660841D.5050003@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4660841D.5050003@garzik.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Jeff Garzik wrote:
> IIRC, Debian was the one OS that really did need a shutdown utility 
> update, as the message says :)

Actually, editing /etc/init.d/halt is enough.  Find the hddown="-h" and
change it to hddown="".

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
