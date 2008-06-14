Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYFNWkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYFNWkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYFNWkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:40:06 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56854 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbYFNWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:40:05 -0400
Date: Sat, 14 Jun 2008 23:39:51 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?unknown-8bit?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] 8139too: clean up spaces and TABs
Message-ID: <20080614213951.GA9261@electric-eye.fr.zoreil.com>
References: <4853BB62.1060109@freemail.hu> <48541165.7050304@freemail.hu> <485421C1.8010102@s5r6.in-berlin.de> <200806142321.37180.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806142321.37180.linux@rainbow-software.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zary <linux@rainbow-software.org> :
[...]
> A more useful thing would be to merge 8139too and 8139cp drivers together so 
> user can just put RTL8139 card in the box and it will work. The current state 
> is completely broken - two drivers for two versions of the chip which have 
> the same PCI IDs.

I am curious to know which distro is not able to handle these drivers
for the user.

The drivers have little in common and the 8139cp driver hints loudly
when it does not recognize the device. 

-- 
Ueimor
