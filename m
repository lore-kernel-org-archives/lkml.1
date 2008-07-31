Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYGaTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYGaTW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYGaTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:22:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53772 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205AbYGaTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:22:20 -0400
X-Sasl-enc: 5W+Dd23NzLcX8rQ46ls1/gz4vPEEjK9NIJBra8Sq951y 1217532138
Date: Thu, 31 Jul 2008 16:22:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Sysrq+B doesn't work on my box
Message-ID: <20080731192215.GA28063@khazad-dum.debian.net>
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com> <20080731143905.GF19665@khazad-dum.debian.net> <c4e36d110807311101h4fea377dsb4470c0935bbd419@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110807311101h4fea377dsb4470c0935bbd419@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Zdenek Kabelac wrote:
> work with the left Alt which I'm not normally using (It's somewhat
> easier to use the right one)
> Any idea why AltGR+SysRQ+b does not work on T61 ?

No, but Lenovo could fix it if they wanted to, since the keyboard controller
is actually implemented in firmware inside the EC (a Renesas H8S uC).  If
you are under warranty, call their tech support and complain :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
