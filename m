Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYJQPbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYJQPbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYJQPa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:30:56 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:39497 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYJQPaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:30:55 -0400
Message-ID: <48F8AF9F.4000303@nortel.com>
Date: Fri, 17 Oct 2008 09:30:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016164602.GA22554@cs181140183.pp.htv.fi> <20081017034717.GA28188@kroah.com> <20081017064751.GE22554@cs181140183.pp.htv.fi> <20081017075544.GB4850@kroah.com> <20081017085604.GA20986@cs181140183.pp.htv.fi>
In-Reply-To: <20081017085604.GA20986@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2008 15:30:40.0653 (UTC) FILETIME=[4FE1B3D0:01C9306D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Oct 17, 2008 at 12:55:44AM -0700, Greg KH wrote:
>> On Fri, Oct 17, 2008 at 09:47:51AM +0300, Adrian Bunk wrote:
>> ...
>>> Packages are built in a chroot with the correct release installed.
>> Then why would this break if they are being built against the correct,
>> older, kernel?
> 
> How could you build userspace "against a kernel"?

I imagine many embedded products regularly build (or even cross-build) a 
kernel and a matching userspace against that kernel, independent of the 
running kernel on the build machine.  I know that we do it every day...

Chris
