Return-Path: <linux-kernel-owner+w=401wt.eu-S1762102AbXELCOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762102AbXELCOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 22:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXELCOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 22:14:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43259 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbXELCOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 22:14:39 -0400
Message-ID: <46452301.4060306@zytor.com>
Date: Fri, 11 May 2007 19:14:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mark@glines.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
References: <20070511170135.7c38615f@chirp> <20070511.170638.35663266.davem@davemloft.net>
In-Reply-To: <20070511.170638.35663266.davem@davemloft.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> 
> All ports above and including 1024 are non-privileged and available to
> anyone.
> 
> Applications which have some requirements in this area need to work
> those things out themselves.

However, there are a large number of applications which have registered
ports in this range.

	-hpa
