Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbXCPPba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbXCPPba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXCPPba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:31:30 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3242 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXCPPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:31:29 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andreas Steinmetz <ast@domdv.de>
Subject: Re: 2.6.20.3: kswapd page allocation failure
Date: Fri, 16 Mar 2007 16:33:59 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
References: <45FA77D1.2060306@domdv.de>
In-Reply-To: <45FA77D1.2060306@domdv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161633.59984.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> Got the following from dmesg of one of my servers last night (happened
> during nightly backup over network):
> 
> kswapd0: page allocation failure. order:3, mode:0x20

	Take a look at this:

http://lkml.org/lkml/2007/3/15/90

Regards,

	Mariusz Kozlowski
