Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZHCQYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZHCQYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZHCQYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:24:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZHCQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:24:14 -0400
From: Martin Rogge <marogge@onlinehome.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
Date: Mon, 3 Aug 2009 18:25:27 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.30.4; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031825.28045.marogge@onlinehome.de>
X-Provags-ID: V01U2FsdGVkX1/tK3xUiKOlB4gWpJgyJMvXUhLZOoY5yDmfcmm
 Sfx8mARYge4vxBOv+VDVdjZgPunDfomJu/7Spowg/B0k6nPY/0
 HJaLXtR7vpiIpWWyb1x7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Osipov Stanislav wrote:

> I  have  a  dual  Pentium-3 system. It based on Asus CUR-DLS mainboard
> with  2  Pentium-3EB  1000MHz (133 MHz FSB) installed. 
> 
> [...]
> 
> But  under 2.6.30.x kernels box freezes without any alerts. TTL before
> freezing  is  about 5-30 mins.
> 
> [...]
> 
> Thanks in advance,
> 
> Osipov Stanislav
> Linux System Administrator.

I also observe system lockups after upgrading to 2.6.30.[34]. The mainboard is 
an MSI-9105 with dual P-3 1400Mhz. TTL is a number of hours (which is going to 
make bisecting hard). Since all lockups have occured with a tainted kernel 
(nvidia) I am currently running a test with an untainted kernel. Should a 
lockup re-occur I will post details.

Martin

