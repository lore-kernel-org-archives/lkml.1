Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYJUUzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYJUUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYJUUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:54:59 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:33978 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYJUUy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:54:58 -0400
Date: Tue, 21 Oct 2008 22:54:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.2: NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Message-ID: <20081021205450.GA26058@electric-eye.fr.zoreil.com>
References: <200810201251.51836.assirati@nonada.if.usp.br> <20081020201306.GA19486@electric-eye.fr.zoreil.com> <200810211040.38893.assirati@nonada.if.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810211040.38893.assirati@nonada.if.usp.br>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joao Luis Meloni Assirati <assirati@nonada.if.usp.br> :
[...]
> I tried to apply your patches (against 2.6.27.2) but they failed.

2.6.27.2 does not include the post-2.6.27 8102 changes. The driver
in 2.6.27-rc1 will be fine if you want to save you the hassles
of patching,

-- 
Ueimor
