Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYLHUK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYLHUK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLHUKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:10:12 -0500
Received: from main.gmane.org ([80.91.229.2]:53871 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYLHUKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:10:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
Date: Mon, 08 Dec 2008 21:08:41 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2008.12.08.20.08.41.100500@wizards.de>
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-136-62.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Dec 2008 20:19:37 +0100, Stefan Richter wrote:

>>>> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
>>>>> The system is a generic old single-core P4 box with a single SATA
>>>>> drive, Gentoo userland and Samba is 3.0.33 (in async mode). The
>>>>> kernel has no patches or binary drivers.
> 
> Holger, it may be unrelated to the issue, but to be sure:  Which network
> card driver do you use?

e1000 with the older PCI/PCI-X 82545GM rev.04 card in a PCI slot.

thanks,
Holger


