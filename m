Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbYKRBlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbYKRBlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYKRBk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:40:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:35062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYKRBk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:40:56 -0500
Message-ID: <49221D23.8040904@kernel.org>
Date: Tue, 18 Nov 2008 10:40:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com> <48B6E69B.1090800@kernel.org> <20080828181720.GB23898@kroah.com> <491BEC4E.9030505@kernel.org> <492136F5.8010903@kernel.org> <20081117171717.GB31306@kroah.com> <49221CE8.1050402@kernel.org>
In-Reply-To: <49221CE8.1050402@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Nov 2008 01:40:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(lkml was missing, adding it back and quoting whole body for reference)

Tejun Heo wrote:
> Greg KH wrote:
>> On Mon, Nov 17, 2008 at 06:18:45PM +0900, Tejun Heo wrote:
>>> (this is a private message)
>>>
>>> PING.  :-)
>> Heh.
>>
>> I've lost this out of my tree, as I didn't know you still wanted this
>> applied.  If you need it for your char-fuse code, then I don't have an
>> objection to it, and you can take it through your tree.
>>
>> Or do you want me to take it through mine?
>>
>> Your choice :)
> 
> I'll push it through Miklos' tree w/ your ACK then.
> 
> Thanks.  :-)
> 


-- 
tejun
