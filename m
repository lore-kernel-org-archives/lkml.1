Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632Ab0A3EHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab0A3EHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 23:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388Ab0A3EHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 23:07:34 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:54719 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab0A3EHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 23:07:34 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 23:07:34 EST
Message-ID: <4B63AF4C.9040003@davidnewall.com>
Date: Sat, 30 Jan 2010 14:32:20 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Derek Atkins <warlord@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Re-enabling non-GPL driver access to disk partition information
References: <sjmd40t3slu.fsf@pgpdev.ihtfp.org> <20100129220601.GA19687@kroah.com>
In-Reply-To: <20100129220601.GA19687@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jan 29, 2010 at 09:15:09AM -0500, Derek Atkins wrote:
>   
>> -EXPORT_SYMBOL_GPL(put_device);
>> +EXPORT_SYMBOL(put_device);
>>     
>
> No, sorry, [...] I can not, and will not, make this change.
>   


Derek,

Consider writing a GPL wrapper module.

David
