Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYC2Be5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYC2Be5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 21:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYC2Ber
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 21:34:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbYC2Beq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 21:34:46 -0400
Message-ID: <47ED9CB4.7010603@garzik.org>
Date: Fri, 28 Mar 2008 21:34:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Gustavo_Guillermo_P=E9rez?= <gustavo@compunauta.com>
CC: linux-kernel@vger.kernel.org, NetDev <netdev@vger.kernel.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: tulip driver receive but not send 2.6.25-rc6-git7
References: <200803281828.39948.gustavo@compunauta.com>
In-Reply-To: <200803281828.39948.gustavo@compunauta.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo Guillermo Pérez wrote:
> I'm putting all wires on the same swirch for testing.
> eth0 is a sis embedded card (good one).
> dealing with dhcp I see that request arrives to the board but the offers never 
> appears on client. system clean no iptables rules, just dhcpd.

> I'm gonna try with rc7-git4 and 2.6.24

Please do.

Also, try the 'dmfe' driver, as it was written specifically for these chips.

	Jeff


