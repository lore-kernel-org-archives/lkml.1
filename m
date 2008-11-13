Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYKMLhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYKMLhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYKMLhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:37:06 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:37278 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYKMLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ajnMgZnGl7kdRfAh7RQrBTgzEhbpcB+WE0BFh9C70d9VkJRQN+4uyKladBrmD9C+aS
         tycdBAezfEd8q2rCK9YYJGKgAeL2peRUXDwA1rJFSowKgWejOWxxR7fgIfgk1kDCBXuQ
         wsy/JFMe7HOjDYwmRmWWblNYrFa1VLYBg2Amk=
Message-ID: <491C1158.8090901@gmail.com>
Date: Thu, 13 Nov 2008 20:36:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take
 #2
References: <475936CE.70703@gmail.com> <475BB5AE.40503@gmail.com>	 <477B71F0.8020706@gmail.com>  <200801031012.22776.rusty@rustcorp.com.au> <1199318319.2044.22.camel@perihelion>
In-Reply-To: <1199318319.2044.22.camel@perihelion>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Thu, 2008-01-03 at 10:12 +1100, Rusty Russell wrote:
> 
>> Oh, sorry.  Jon is now module-init-tools maintainer, and I've cc'd him and 
>> forwarded your original patch.
> 
> Ta. I was semi-offline last week due to holidays, but already saw the
> original mail and have another fix for debug sections - will sort it.

Jon, this patch hasn't made into module-init-tools after 10 months.  Ping?

Thanks.

-- 
tejun
