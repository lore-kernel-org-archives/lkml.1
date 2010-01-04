Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472Ab0ADXxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ADXxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0ADXxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:53:12 -0500
Received: from khc.piap.pl ([195.187.100.11]:35443 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0ADXxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:53:11 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Thanasis <thanasis@asyr.hopto.org>
Cc: gentoo-user@lists.gentoo.org, Joshua Murphy <poisonbl@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [gentoo-user] RAM installed vs reported
References: <4B3B3043.20400@asyr.hopto.org>
	<200912301208.54359.dirk.heinrichs@online.de>
	<4B3B38F2.6090006@asyr.hopto.org>
	<m3fx6r8a0l.fsf@intrepid.localdomain>
	<4B3CF04E.8070603@asyr.hopto.org>
	<m3vdfmosha.fsf@intrepid.localdomain>
	<4B406CDF.7010301@asyr.hopto.org>
	<m3aawulr8t.fsf@intrepid.localdomain>
	<4B4138AB.3060602@asyr.hopto.org>
	<c30988c31001040651l8351224l4eb1f1a54610653e@mail.gmail.com>
	<4B422A86.3070805@asyr.hopto.org> <4B424903.1000808@asyr.hopto.org>
Date: Tue, 05 Jan 2010 00:53:07 +0100
In-Reply-To: <4B424903.1000808@asyr.hopto.org> (thanasis@asyr.hopto.org's
	message of "Mon, 04 Jan 2010 22:01:07 +0200")
Message-ID: <m3fx6l4ecc.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis@asyr.hopto.org> writes:

> I tried option: 2G/2G user/kernel split (for full 2G low memory), but X
> would not start. So i reverted back to CONFIG_HIGHMEM4G.

Binary proprietary module maybe?
-- 
Krzysztof Halasa
