Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYD2GBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYD2GBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbYD2GBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:01:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53428 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbYD2GBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:01:05 -0400
Message-ID: <4816B99F.7040102@garzik.org>
Date: Tue, 29 Apr 2008 02:01:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Driver for IXP4xx built-in Ethernet ports
References: <m3r6d05ucg.fsf@maximus.localdomain>
In-Reply-To: <m3r6d05ucg.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Adds a driver for built-in IXP4xx Ethernet ports.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

the ifdefs are really ugly and want cleaning, but the rest seems sane. 
applied

