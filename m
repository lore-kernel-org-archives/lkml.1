Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbXGXI2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbXGXI2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXGXI2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:28:37 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:34214 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821AbXGXI2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:28:36 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH] usb/atm: fix Kconfig garbage
Date: Tue, 24 Jul 2007 10:28:55 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net
References: <20070723065604.GA8525@gollum.tnic>
In-Reply-To: <20070723065604.GA8525@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241028.56325.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> When entered, the menu point "USB DSL modem support" in menuconfig, path [Device Drivers->USB
> Support] shows no entries but "^@" instead. The following fixes it.

is the problem that there are no entries, or that "^@" is displayed?  If there are no
entries then presumably you didn't turn on ATM support.

Ciao,

Duncan.
