Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0BYHLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:11:09 -0500
Received: from 1wt.eu ([62.212.114.60]:57642 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0BYHLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:11:08 -0500
Date: Thu, 25 Feb 2010 08:11:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 802.11 development process - extended documentation
Message-ID: <20100225071104.GA20914@1wt.eu>
References: <43e72e891002241618w10d5c45ar9303f074d0228217@mail.gmail.com> <3f9a31f41002242053r169255d2hf2585aeb55174a92@mail.gmail.com> <43e72e891002242119u77fdfd30m2d17a1e48fe2e712@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e891002242119u77fdfd30m2d17a1e48fe2e712@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 09:19:41PM -0800, Luis R. Rodriguez wrote:
> > What is the status of Wireless in Linux 2.4
> 
> Heh, umm, I have no clue. Dead?

It could be considered like this given the pace at which Wireless
evolves around. Basically, if you have a WiFi NIC which works in
2.4, there is no reason for it to break tomorrow. However if yours
is not supported, don't hope to see it added later. Some exotic
drivers may sometimes be found in embedded distros such as OpenWrt
though.

Willy

