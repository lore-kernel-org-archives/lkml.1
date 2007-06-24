Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbXFXUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbXFXUET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXFXUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:04:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5230 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXFXUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:04:02 -0400
Date: Sun, 24 Jun 2007 22:04:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: acme@ghostprotocols.net
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: DCCP: 2.6.22-rc5-git8 compile warning
In-Reply-To: <Pine.LNX.4.64.0706242200130.11964@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706242203380.11964@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706242200130.11964@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>git tree a06381fec77bf88ec6c5eb6324457cb04e9ffd69 (last commit ID) 
>gives:
>
>/ws/linux-2.6.22/net/dccp/ipv4.c:589: warning: initialization from 
>incompatible
>/ws/linux-2.6.22/net/dccp/ipv6.c:387: warning: initialization from 
>incompatible

Extra patches with quilt caused that. Sorry for the noise.


	Jan
-- 
