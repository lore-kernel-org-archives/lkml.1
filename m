Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXHTQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXHTQx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760077AbXHTQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:53:20 -0400
Received: from baldrick.fusednetworks.co.uk ([83.142.228.48]:57630 "EHLO
	baldrick.fusednetworks.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759941AbXHTQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:53:20 -0400
Message-ID: <46C9C6FB.2010609@bootc.net>
Date: Mon, 20 Aug 2007 17:53:15 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
References: <46C6C145.70506@abacustree.com> <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com> <46C6FF93.4040509@bootc.net> <yw1xmywokfik.fsf@thrashbarg.mansr.com> <46C71E1B.40702@bootc.net>
In-Reply-To: <46C71E1B.40702@bootc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Boot wrote:
>>> I'll probably just try and recompile the kernel with 8k stacks and see
>>> how it goes. Screw the support, we're unlikely to get it anyway. :-P
>>>     
>>
>> Please report how this works out.
>>   
>
> I will. This will probably be on Monday now, since the machine isn't 
> accepting SysRq requests over the serial console. :-(

OK, with the recompiled kernel this appears to work just fine now. I've 
been pounding the box all day with rsyncs, VMware VMs, plenty of web 
serving (inc. SVN) and so far it's holding up just fine. Cheers for the 
diagnosis.

Many thanks,
Chris

