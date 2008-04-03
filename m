Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYDCUIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYDCUIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYDCUI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:08:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53966 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753014AbYDCUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:08:26 -0400
Date: Thu, 3 Apr 2008 16:08:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: david@lang.hm
cc: Xavier Bestel <xavier.bestel@free.fr>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: ASUS ScreenDuo
In-Reply-To: <alpine.DEB.1.10.0804031303210.22292@asgard.lang.hm>
Message-ID: <Pine.LNX.4.44L0.0804031606350.5288-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 david@lang.hm wrote:

> for future use, what was it that made everyone decide that this is going 
> to show up as a storage device?
> 
> with a screen and buttons I would have guessed a HID of some sort.

During enumeration it reports that it is a USB mass-storage-class 
device.  Look at Xavier's lsusb output in the original posting.

Alan Stern

