Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKCTwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKCTwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYKCTwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:52:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40208 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYKCTwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:52:12 -0500
Message-ID: <490F5667.3080904@garzik.org>
Date: Mon, 03 Nov 2008 14:52:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Subbu Seetharaman <subbus@serverengines.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] benet: BladeEngine 10Gb NIC driver
References: <20081103122512.06063fc9@mailhost.serverengines.com> <20081103193641.GA12552@kroah.com>
In-Reply-To: <20081103193641.GA12552@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Nov 03, 2008 at 04:25:12AM -0800, Subbu Seetharaman wrote:
>> If we could get more specific feedback about the areas that require
>> cleanup, we can take care of them quickly.  
>>
>> Since the last posting, we have brought up the driver in a PPC system
>> and fixed some endianness issues.  As soon as I have some specific
>> feedback, we can update the driver with these fixes as well.
>>
>> Please let me know as soon as the driver is in the staging area.
> 
> Does someone have a pointer to the driver, so that we can see what is
> needed to be done?

It was in my email :)  Repeating,

The 'benet' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

It should be suitable for pulling directly into staging.

	Jeff


