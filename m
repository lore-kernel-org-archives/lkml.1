Return-Path: <linux-kernel-owner+w=401wt.eu-S1423264AbXBHTsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423264AbXBHTsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423290AbXBHTsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:48:35 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423264AbXBHTsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:48:33 -0500
Message-ID: <45CB7E85.4010303@zytor.com>
Date: Thu, 08 Feb 2007 11:48:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Josh Boyer <jwboyer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New git server on kernel.org?
References: <625fc13d0702080807m1576e3cr152295aa2d88143f@mail.gmail.com> <45CB5DB8.2070104@zytor.com> <20070208193456.GA9798@osiris.ibm.com>
In-Reply-To: <20070208193456.GA9798@osiris.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, Feb 08, 2007 at 09:28:24AM -0800, H. Peter Anvin wrote:
>> Josh Boyer wrote:
>>> Hi All,
>>> Did the migration of the git stuff to a new dedicated server on
>>> kernel.org ever happen?  IIRC, it was supposed to happen the 5th of
>>> Feb. or so.
>> It hasn't happened yet, no, and since the machine hasn't yet shipped out, it won't happen this week.
>>
>> The perils of volunteer labor...
> 
> Since yesterday I cannot pull anymore, did something change on kernel.org?
> 
> ~/linux-2.6> git --version
> git version 1.4.2.3
> ~/linux-2.6> git pull
> fatal: unexpected EOF
> Fetch failure: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 

This *ONLY* happens with Linus' repository; as far as we can tell 
something got funky with Linus' repository on at least one of the 
servers.  I have restarted the rsync process which seems to have been 
stuck for a while.

	-hpa
