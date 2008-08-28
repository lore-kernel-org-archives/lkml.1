Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYH1Tk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYH1Tk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYH1Tkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:40:46 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:46475 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYH1Tkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:40:45 -0400
Message-ID: <48B6E62D.4060606@freescale.com>
Date: Thu, 28 Aug 2008 12:53:49 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arnd Bergmann <arnd@arndb.de>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
References: <Pine.LNX.4.44L0.0808281320010.2464-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808281320010.2464-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> This was done deliberately.  The relevant standards state that a USB
> device can have no more than one peripheral interface.

Does building a kernel image that can run on different hardware without 
rebuilding also violate the "relevant standards"?

And who's to say that there aren't multiple USB devices on a single 
board, that just happen to share a CPU and memory? :-)

-Scott
