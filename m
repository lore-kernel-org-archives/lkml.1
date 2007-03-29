Return-Path: <linux-kernel-owner+w=401wt.eu-S1945910AbXC2Wco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910AbXC2Wco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945909AbXC2Wco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:32:44 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56163 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945907AbXC2Wcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:32:43 -0400
Date: Fri, 30 Mar 2007 00:31:25 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jesse <Jesse@icplus.com.tw>
Cc: Jeff Garzik <jeff@garzik.org>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       penberg@cs.Helsinki.FI, akpm@osdl.org, dvrabel@cantab.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       david@pleyades.net
Subject: Re: IP1000A: About IC Plus IP1000A Linux driver current status
Message-ID: <20070329223125.GA10765@electric-eye.fr.zoreil.com>
References: <AA68EB0EBA29BA40A06B700C33343EEF011E5CF2@fileserver.icplus.com.tw> <20070328212212.GA10567@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328212212.GA10567@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
[...]

BUG: spinlock already unlocked on CPU#0, swapper/0

Almost perfect...

--- 
Ueimor
