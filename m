Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYCNPci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYCNPci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYCNPc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:32:29 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60810 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYCNPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:32:29 -0400
Date: Fri, 14 Mar 2008 16:00:02 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: broken access to a USB HID device after suspend
Message-ID: <20080314150002.GA16182@eazy.amigager.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080314071712.GA15654@dose.home.local> <Pine.LNX.4.44L0.0803141034260.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0803141034260.4478-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 10:36:06 -0400, Alan Stern wrote:

[...]

> Have you tried using the LCD device with a different computer?  It's 
> worth a try, just to rule out the possibility that something is wrong 
> with your computer's USB hardware.

OK. When it happens again, I'll plug the USB cable into my notebook and
try to use hidmon on the notebook.

Regards,
Tino
