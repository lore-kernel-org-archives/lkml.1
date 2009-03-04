Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZCDWk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZCDWk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZCDWkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:40:13 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:54264 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbZCDWkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:40:12 -0500
Date: Wed, 4 Mar 2009 23:43:10 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael =?unknown-8bit?B?QsO8a2Vy?= <m.bueker@berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Message-ID: <20090304224310.GA29043@electric-eye.fr.zoreil.com>
References: <200903041828.49972.m.bueker@berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903041828.49972.m.bueker@berlin.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Büker <m.bueker@berlin.de> :
[...]
> With both 2.6.27.19 and 2.6.28.7, I am experiencing "transmit timed out" 
> errors as reported by the netdev watchdog, for both my PCMCIA Ethernet 
> adapters, using the r8169 and 8139too drivers respectively.

Can you describe the symptoms a bit more specifically ?

The kernel displays a scary warning, I can guess that it is almost surely
associated with some loss of network connectivity for a few seconds at the
very least but it is a bit hard to figure the real scale of your problem.

Please scare me. :o)

[...]
> as both kernel config files. I'll gladly provide more information as it is 
> requested.

lspci -vx and a complete dmesg.

Can you identify a kernel which worked flawlessly ?

-- 
Ueimor
