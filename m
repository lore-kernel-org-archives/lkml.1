Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYAGIXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYAGIXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYAGIXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:23:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47112
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754945AbYAGIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:23:43 -0500
Date: Mon, 07 Jan 2008 00:23:42 -0800 (PST)
Message-Id: <20080107.002342.10040673.davem@davemloft.net>
To: linux@horizon.com
Cc: romieu@fr.zoreil.com, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@linux-foundation.org
Subject: Re: 2.6.24-rc6 oops in net_tx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080107064350.5042.qmail@science.horizon.com>
References: <20080106235719.GA10588@electric-eye.fr.zoreil.com>
	<20080107064350.5042.qmail@science.horizon.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: linux@horizon.com
Date: 7 Jan 2008 01:43:50 -0500

> Thanks!  I got the patch from
> http://marc.info/?l=linux-netdev&m=119756785219214
> (Which didn't make it into -rc7; please fix!)
> and am recompiling now.

Jeff is busy so he's asked me to pick up the more important
driver bug fixes that get posted.

I'll push this around, thanks.
