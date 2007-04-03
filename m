Return-Path: <linux-kernel-owner+w=401wt.eu-S965309AbXDCQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbXDCQsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965418AbXDCQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:48:09 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:53732 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965416AbXDCQsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:48:08 -0400
Date: Tue, 3 Apr 2007 18:47:04 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Carlo Florendo <subscribermail@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel source dependency
In-Reply-To: <20070403081853.6590ef84.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.61.0704031846330.10155@yvahk01.tjqt.qr>
References: <46120EBE.8080705@gmail.com> <20070403081853.6590ef84.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 3 2007 08:18, Randy Dunlap wrote:
>
>Hi,
>Without ncurses installed, you should see these messages:
>
>	echo " *** Unable to find the ncurses libraries."
>	echo " *** make menuconfig require the ncurses libraries"
>	echo " *** "
>	echo " *** Install ncurses (ncurses-devel) and try again"
>	echo " *** "
>
>Do you not see them?  or do you need something different?

Perhaps libreadline-devel? Though ncurses-devel will *most likely* have a
dependency on that, more even than the kernel does on ncurses-devel ;-)


Jan
-- 
