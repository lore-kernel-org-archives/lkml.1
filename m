Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYC0SGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYC0SGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYC0SGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:06:38 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:8834 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbYC0SGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:06:37 -0400
X-Belgacom-Dynamic: yes
Date: Thu, 27 Mar 2008 19:06:33 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Bryan Wu <cooloney@kernel.org>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver registering from actual watchdog device/driver registering so we can cleanly load/unload (v2)
Message-ID: <20080327180633.GA15320@infomag.infomag.iguana.be>
References: <1206644012-10135-1-git-send-email-cooloney@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206644012-10135-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> v1-v2:
>  - fixup __initdata with __initconst and __devinitdata with __devinitconst
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Added this to the linux-2.6-watchdog-mm tree.

Greetings,
Wim.

