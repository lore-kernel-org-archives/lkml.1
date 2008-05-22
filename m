Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbYEVUde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbYEVUde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYEVUdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:33:22 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:43146 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYEVUdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:33:22 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: protect Cisco HDLC state changes with a spinlock.
References: <m3od72gqxf.fsf@maximus.localdomain> <48354906.2010409@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 22 May 2008 22:33:18 +0200
In-Reply-To: <48354906.2010409@garzik.org> (Jeff Garzik's message of "Thu\, 22 May 2008 06\:20\:54 -0400")
Message-ID: <m3zlqi6pv5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

>> WAN: protect Cisco HDLC state changes with a spinlock.
>>     Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
>
> applied

Thanks Jeff, David.
-- 
Krzysztof Halasa
