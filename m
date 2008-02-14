Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYBNXuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYBNXuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbYBNXuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:50:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36314 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760054AbYBNXug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:50:36 -0500
Message-ID: <47B4D3C9.70009@garzik.org>
Date: Thu, 14 Feb 2008 18:50:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <20080214235221.GA6399@kroah.com>
In-Reply-To: <20080214235221.GA6399@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I have some patches in my pci tree to get rid of some pci_find_slot()
> usages, as well, so we are almost rid of these old functions.


Good...  I was avoiding that area, silently hoping that someone else 
would handle that part for me :)

	Jeff


