Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYEIV6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYEIV6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYEIV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:58:36 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:44138 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYEIV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:58:36 -0400
X-Originating-IP: [74.251.48.254]
Date: Fri, 9 May 2008 16:58:32 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jeff@garzik.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, csnook@redhat.com
Subject: Re: [GIT]: Networking
Message-ID: <20080509165832.12488cb8@osprey.hogchain.net>
In-Reply-To: <20080509.144359.194792251.davem@davemloft.net>
References: <alpine.LFD.1.10.0805081848170.2940@woody.linux-foundation.org>
	<4824606E.3040409@garzik.org>
	<alpine.LFD.1.10.0805090805210.3142@woody.linux-foundation.org>
	<20080509.144359.194792251.davem@davemloft.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2008 14:43:59 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> BTW, this reminds me, did we get that driver in for the device the
> EEPC machines use?  I have this strange feeling like that slipped
> through the cracks.

That'd be the Atheros/Attansic L2 NIC.  I don't think it's quite ready
yet.

[Adding Chris Snook to the cc list.]
