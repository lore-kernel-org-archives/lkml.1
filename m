Return-Path: <linux-kernel-owner+w=401wt.eu-S934014AbYCFSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbYCFSFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYCFSFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:05:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34344 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbYCFSFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:05:43 -0500
Message-ID: <47D03272.9080209@garzik.org>
Date: Thu, 06 Mar 2008 13:05:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange> <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange> <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange> <39B20DF628532344BC7A2692CB6AEE0702679018@orsmsx420.amr.corp.intel.com>
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE0702679018@orsmsx420.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaston, Jason D wrote:
> If you disable the IDE Redirection in BIOS on that system, the 0x29b6
> controller should not appear.  If you are not using this, it would be
> interesting to see if this effects what you are seeing.


I think its fair to say that a certain amount of Linux users will 
inevitably have this option enabled in their BIOS.  We should have a 
plan to deal with this sanely...?

	Jeff


