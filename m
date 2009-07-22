Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZGVRuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZGVRuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZGVRuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:50:20 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:14559 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbZGVRuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:50:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHPtZkpR9cYI/2dsb2JhbADUPAmEBQWBP2M
Date: Wed, 22 Jul 2009 19:50:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: SBC-FITPC2 watchdog support
Message-ID: <20090722175018.GJ2155@infomag.iguana.be>
References: <4A5F1D12.2080907@compulab.co.il> <20090717084303.GA11781@centrinvest.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717084303.GA11781@centrinvest.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

> On 197, 07 16, 2009 at 03:29:06PM +0300, Denis Turischev wrote:
> > Adds support to watchdog timer on SBC-FITPC2 board by Compulab.
> > 
> > Signed-off-by: Denis Turischev <denis@compulab.co.il>
> > Signed-off-by: Mike Rapoport <mike@compulab.co.il>
> 
> 1. please add [PATCH] to email subject next time
> 2. patch is wordwrapped by mailer, read Documentation/email-clients.txt
> 3. use request_region() to reserve ioport region
> 4. you can use DMI info from you reboot quirk patch to test that you
>    are really running on SBC-FITPC2. You'll also get module autoload 
>    as a bonus.

Can you sent me the updated version for review when you are ready?

Thanks,
Wim.

