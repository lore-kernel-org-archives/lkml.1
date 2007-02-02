Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbXBBKtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbXBBKtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 05:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbXBBKtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 05:49:20 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:36595 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932666AbXBBKtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 05:49:19 -0500
Date: Fri, 2 Feb 2007 11:49:18 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Julien BLACHE <jb@jblache.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Fagyal Csongor <concept@conceptonline.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
Message-ID: <20070202104918.GD1693@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Julien BLACHE <jb@jblache.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Fagyal Csongor <concept@conceptonline.hu>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de> <42007.80.98.159.250.1170369983.squirrel@www.hunhost.com> <20070201145815.199bfe1a@freekitty> <20070202063104.GA13130@cip.informatik.uni-erlangen.de> <873b5o25zs.fsf@sonic.technologeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873b5o25zs.fsf@sonic.technologeek.org>
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Next time sky2 hangs on me I'll try to reset the PHY and see if that
> helps. I can usually trigger the hang by doing a couple of ifconfig
> up/down on the interface, though I'm not getting any error message
> from the driver when that happens.

same for me. In dmesg is absolut nothing. I change my fix script, too.
To see if that is enough to resolv the problem.

        Thomas
