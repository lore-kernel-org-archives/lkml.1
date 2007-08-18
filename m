Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXHRQks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXHRQks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXHRQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:40:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33319 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbXHRQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:40:38 -0400
Date: Sat, 18 Aug 2007 18:40:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Chris Boot <bootc@bootc.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
In-Reply-To: <46C71E1B.40702@bootc.net>
Message-ID: <Pine.LNX.4.64.0708181839550.5186@fbirervta.pbzchgretzou.qr>
References: <46C6C145.70506@abacustree.com> <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com>
 <46C6FF93.4040509@bootc.net> <yw1xmywokfik.fsf@thrashbarg.mansr.com>
 <46C71E1B.40702@bootc.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18 2007 17:28, Chris Boot wrote:
>
> I will. This will probably be on Monday now, since the machine isn't
> accepting SysRq requests over the serial console. :-(

Ah yeah, stupid null-modem cables!
You can also trigger sysrq from /proc/sysrq-trigger (well, as long
as the system lives)

	Jan
-- 
