Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYANAKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYANAKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 19:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYANAKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 19:10:12 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48202 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYANAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 19:10:10 -0500
X-Sasl-enc: BprIIJMl9fOkYBLWUrsoL0NRQQr1PWA3Hj7SLF4stBgV 1200269408
Date: Sun, 13 Jan 2008 22:10:05 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Lenovo ThinkPads need acpi_osi="Linux"
Message-ID: <20080114001005.GF10693@khazad-dum.debian.net>
References: <20080112022348.GC27524@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112022348.GC27524@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit more on this issue.  I have received a report that on a X61, it
actually works the opposite from the T61 and you need acpi_osi="!Linux" to
get the "mute" key to work.

Well, I am asking the users to track down exactly *where* the mute key is
comming from in each case (ACPI or keyboard controller).  When I have the
results, I will send an update to this thread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
