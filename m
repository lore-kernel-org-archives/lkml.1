Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGDWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGDWJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYGDWJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:09:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2203 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752729AbYGDWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:09:28 -0400
Date: Fri, 4 Jul 2008 18:09:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       <gregkh@suse.de>
Subject: Re: usb-storage: quirk around v1.11 firmware on Nikon D4
In-Reply-To: <20080704195940.GA17510@redhat.com>
Message-ID: <Pine.LNX.4.44L0.0807041808100.17654-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Dave Jones wrote:

> usb-storage: quirk around v1.11 firmware on Nikon D40
...
> -UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0110,
> +UNUSUAL_DEV(  0x04b0, 0x0411, 0x0100, 0x0111,
>  		"NIKON",
>  		"NIKON DSC D80",

You updated the entry for the D80, not the D40.  Maybe they both need 
to be updated?

Alan Stern

