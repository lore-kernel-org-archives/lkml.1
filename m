Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYKDJha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYKDJha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYKDJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:37:20 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58969 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYKDJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:37:18 -0500
Date: Tue, 4 Nov 2008 10:37:10 +0100
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
Message-ID: <20081104093710.GC15846@gamma.logic.tuwien.ac.at>
References: <20081103153118.GA27552@gamma.logic.tuwien.ac.at> <Pine.LNX.4.44L0.0811031403180.2194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811031403180.2194-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mo, 03 Nov 2008, Alan Stern wrote:
> What happens if you leave the modem turned off until after Linux is 
> running?  If it does not show up then a usbmon trace would be helpful 
> (see Documentation/usb/usbmon.txt for instructions).

I can run usbmon, but I am not sure what you mean with "leave the modem
turned off until after Linux is running".

If I start from turned off state of the laptop and boot into linux the
device is not showing up. Is it that state you are interested in getting
the usbmon output?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BARSTIBLEY
A humorous device such as a china horse or small naked porcelain
infant which jocular hosts use of piss water into your Scotch with.
			--- Douglas Adams, The Meaning of Liff
