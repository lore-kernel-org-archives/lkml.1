Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbYAGAJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbYAGAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 19:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYAGAJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 19:09:49 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:51032 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041AbYAGAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 19:09:48 -0500
Date: Mon, 7 Jan 2008 00:57:19 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: linux@horizon.com
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, jgarzik@pobox.com
Subject: Re: 2.6.24-rc6 oops in net_tx_action
Message-ID: <20080106235719.GA10588@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>, linux@horizon.com,
	linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	shemminger@linux-foundation.org, jgarzik@pobox.com
References: <20080106222942.26950.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106222942.26950.qmail@science.horizon.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com <linux@horizon.com> :
> Kernel is 2.6.24-rc6 + linuxpps patches, which are all to the serial
> port driver.
> 
> 2.6.23 was known stable.  I haven't tested earlier 2.6.24 releases.
> I think it happened once before; I got a black-screen lockup with
> keyboard LEDs blinking, but that was with X running so I couldn't see a
> console oops.  But given that I installed 2.6.24-rc6 about 24 hours ago,
> that's a disturbing pattern.

It is probably this one:

http://marc.info/?t=119782794000003&r=1&w=2

-- 
Ueimor
