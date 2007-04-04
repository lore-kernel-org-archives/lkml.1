Return-Path: <linux-kernel-owner+w=401wt.eu-S2993042AbXDDTOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993042AbXDDTOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993045AbXDDTOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:14:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61634 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993042AbXDDTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:13:57 -0400
Date: Wed, 4 Apr 2007 12:14:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 53/90] ARM: OMAP: Fix warning in timer32k.c
Message-Id: <20070404121421.eb90a58d.randy.dunlap@oracle.com>
In-Reply-To: <11757101123620-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100661228-git-send-email-tony@atomide.com>
	<11757100691131-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:32 -0400 Tony Lindgren wrote:

> From: Dirk Behme <dirk.behme_at_gmail.com>

NAK the obfuscated email address.
And in the S-O-B line as well.

> ARM: OMAP: Fix warning in timer32k.c if CONFIG_NO_IDLE_HZ
> isn't set:
> 
> arch/arm/plat-omap/timer32k.c:221: warning:
> 'omap_32k_timer_handler' defined but not used
> 
> Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/plat-omap/timer32k.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
