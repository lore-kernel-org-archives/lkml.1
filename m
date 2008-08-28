Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYH1NjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYH1NjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbYH1NjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:39:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44862 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYH1NjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:39:10 -0400
X-Sasl-enc: bhSMnxeo+Hc1qVg1xSSHrUdBM/eNulnQHhMJ5IumjMqM 1219930748
Date: Thu, 28 Aug 2008 10:39:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: thinkpad-acpi: wan radio control is not
	experimental
Message-ID: <20080828133900.GA3584@khazad-dum.debian.net>
References: <48B5D11E.5090209@goop.org> <20080827231223.GB18081@khazad-dum.debian.net> <48B5E2C4.7060803@goop.org> <20080828014647.GA24365@khazad-dum.debian.net> <48B623E1.3010508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B623E1.3010508@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Jeremy Fitzhardinge wrote:
> The WWAN radio control has been working well for over three years,
> and is no longer experimental.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

I have queued it and since it is an one-liner with zero chance of
causing problems, I will ask Andi to merge it for 2.6.27.  If he doesn't
agree, it will be merged for 2.6.28.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
