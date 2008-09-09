Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYIIDMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYIIDMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYIIDMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:12:15 -0400
Received: from stinky.trash.net ([213.144.137.162]:59340 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYIIDMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:12:14 -0400
Message-ID: <48C5E97F.3040800@trash.net>
Date: Tue, 09 Sep 2008 05:11:59 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kaos@ocs.com.au, linux-kernel@vger.kernel.org
Subject: Re: Recent copy of libpcap from CVS
References: <48C51E58.7080900@trash.net>	<19419.1220918852@ocs10w> <20080908.171055.170770457.davem@davemloft.net>
In-Reply-To: <20080908.171055.170770457.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Keith Owens <kaos@ocs.com.au>
> Date: Tue, 09 Sep 2008 10:07:32 +1000
>
>   
>> Patrick McHardy (on Mon, 08 Sep 2008 14:45:12 +0200) wrote:
>>     
>>> Dave put a recent copy up at:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/libpcap.git
>>>       
>> Thanks, but that is still version 0.9.8 with no support for usb.
>> It defines DLT_USB and DLT_USB_LINUX but has no code to actually
>> read from /dev/usbmon.  I need the CVS version of libpcap.
>>     
>
> Sorry that's the most recent CVS tree Patrick had when I built that
> GIT repo.

Thats odd, the version I had has USB support and that one also appears
to be missing my VLAN patches that are in current CVS.

I'll try to figure out what went wrong and send you both a new tarball.
