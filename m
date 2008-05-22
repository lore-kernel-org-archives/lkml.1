Return-Path: <linux-kernel-owner+w=401wt.eu-S936761AbYEVKVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936761AbYEVKVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbYEVKU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:20:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59255 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbYEVKU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:20:57 -0400
Message-ID: <48354906.2010409@garzik.org>
Date: Thu, 22 May 2008 06:20:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] WAN: protect Cisco HDLC state changes with a spinlock.
References: <m3od72gqxf.fsf@maximus.localdomain>
In-Reply-To: <m3od72gqxf.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> WAN: protect Cisco HDLC state changes with a spinlock.
>     
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

applied


