Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab0BCDP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:15:57 -0500
Received: from kroah.org ([198.145.64.141]:55765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0BCDPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:15:55 -0500
Date: Tue, 2 Feb 2010 18:10:49 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Derek Atkins <warlord@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
Message-ID: <20100203021049.GA17576@kroah.com>
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org> <20100129220601.GA19687@kroah.com> <4B63AF4C.9040003@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B63AF4C.9040003@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 02:32:20PM +1030, David Newall wrote:
> Greg KH wrote:
>> On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:
>>   
>>> -EXPORT_SYMBOL_GPL(put_device);
>>> +EXPORT_SYMBOL(put_device);
>>>     
>>
>> No, sorry, [...] I can not, and will not, make this change.
>>   
>
>
> Derek,
>
> Consider writing a GPL wrapper module.

Ah, the old "GPL condom" try.  Sorry, but this has been tried many times
in the past, and have been shut down every time.  See the Samba history
of this for lots of details as to why this does not work.

good luck,

greg k-h
