Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYCBN4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYCBN4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 08:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYCBN4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 08:56:06 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:57778 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYCBN4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 08:56:05 -0500
Message-ID: <47CAB23C.1010602@davidnewall.com>
Date: Mon, 03 Mar 2008 00:27:16 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org
Subject: Re: swap file over jffs2 partition
References: <47C772E9.2000000@gmx.net>	 <1204276763.18969.10.camel@tara.firmix.at>  <47C84B40.6000501@gmx.net> <1204458909.4078.30.camel@gimli.at.home>
In-Reply-To: <1204458909.4078.30.camel@gimli.at.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> The wear-levelling only makes all erase blocks/chunks/... wear out at
> the same rate (at least more or less). It doesn't avoid or reduce
> wearing out, it just distributes it.
>   

Surely a unit with one defective block and a squillion good blocks is
faulty.  Sure it is.  It has a fault, which is what it means to be
faulty.  Spread the wear of that one block over all squillion and one
blocks and you get a much longer lifetime.  It seems intuitive that
distributing wear significantly increases time to failure.
