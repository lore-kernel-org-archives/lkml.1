Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXL0KLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXL0KLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 05:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXL0KLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 05:11:23 -0500
Received: from cardassian.kabelfoon.nl ([62.45.45.18]:51050 "EHLO
	cardassian.kabelfoon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbXL0KLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 05:11:22 -0500
Message-ID: <47737A44.4010909@caiway.nl>
Date: Thu, 27 Dec 2007 11:11:16 +0100
From: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/60] 2.6.23-stable review
References: <20071213065039.GA6867@kroah.com> <4763FC4C.8000809@caiway.nl> <20071215180820.GB7587@suse.de>
In-Reply-To: <20071215180820.GB7587@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Dec 15, 2007 at 05:09:48PM +0100, Jan Evert van Grootheest wrote:
>   
>> Greg KH wrote:
>>     
>>> This is the start of the stable review cycle for the 2.6.23.10 release.
>>> There are 60 patches in this series, all will be posted as a response to
>>> this one.  If anyone has any issues with these being applied, please let
>>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>>> to add a Signed-off-by: line to the patch, please respond with it.
>>>
>>>   
>>>       
>> Hi Greg,
>>
>> Do you think it might be possible to add the subjects of the patches
>> next time in the announcement? This would give people an easy way
>> (besides the diffstat) to check what is getting fixed.
>>     
>
> The subject of the individual patches are in the email thread that is
> attached to this announcement, so it should be quite simple to get this
> information by just looking in your mail reader :)
>
> Also, it would be hard to do this, unless someone has a patch to quilt
> to provide this kind of information?
>
>   
Greg,

I think nowadays most people that read lkml use lkml.org or comparable 
services. And lkml.org does not show the subject in the thread list.

But, well, I guess that's more of an issue for lkml.org to do something 
about because it really is about navigating mail threads.

and... -ENOPATCH for quilt.

So no more comments from me and I go in search of a different webservice 
that allows to read lkml with mail subjects in the navigation.

-- Jan Evert
