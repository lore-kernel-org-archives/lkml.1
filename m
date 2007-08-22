Return-Path: <linux-kernel-owner+w=401wt.eu-S934272AbXHVXCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbXHVXCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759745AbXHVXCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:02:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37607 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbXHVXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:02:16 -0400
Message-ID: <46CCC010.8070207@oracle.com>
Date: Wed, 22 Aug 2007 16:00:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTTAINERS: update DCO info
References: <20070822082421.5c20b3da.randy.dunlap@oracle.com> <1187823476.24819.52.camel@localhost>
In-Reply-To: <1187823476.24819.52.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2007-08-22 at 08:24 -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Update URL for DCO (old URL is invalid).
>> Also, point to SubmittingPatches for the current DCO.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  MAINTAINERS |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> --- linux-2.6.23-rc3-git2.orig/MAINTAINERS
>> +++ linux-2.6.23-rc3-git2/MAINTAINERS
>> @@ -45,8 +45,11 @@ trivial patch so apply some common sense
>>  
>>  	PLEASE remember that submissions must be made under the terms
>>  	of the OSDL certificate of contribution
>> -	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
>> +	(http://old.linux-foundation.org/newsroom/press_releases/2004/2004_05_24_dco.html)
>>  	and should include a Signed-off-by: line.
>> +	The current certificate is also documented in
>> +	Documentation/SubmittingPatches as the Developer's Certificate
>> +	of Origin (DCO).
> 
> Why have an external link which may go out of date
> when we already have the cert?
> 
> It's really short, we could just quote it.

I wouldn't bother repeating it, but I'll happily remove the URL
and just refer to Documentation/SubmittingPatches.  I think that
the latter is a good place for it to stay.


> Maybe it should be a separate file
> Documentation/Developer_Certificate_of_Origin
> and referenced directly.
> 
> 	Developer's Certificate of Origin 1.1
> 
> 	By making a contribution to this project, I certify that:
> 
> 	(a) The contribution was created in whole or in part by me and I
> 	    have the right to submit it under the open source license
> 	    indicated in the file; or
> 
> 	(b) The contribution is based upon previous work that, to the best
> 	    of my knowledge, is covered under an appropriate open source
> 	    license and I have the right under that license to submit that
> 	    work with modifications, whether created in whole or in part
> 	    by me, under the same open source license (unless I am
> 	    permitted to submit under a different license), as indicated
> 	    in the file; or
> 
> 	(c) The contribution was provided directly to me by some other
> 	    person who certified (a), (b) or (c) and I have not modified
> 	    it.
> 
> 	(d) I understand and agree that this project and the contribution
> 	    are public and that a record of the contribution (including all
> 	    personal information I submit with it, including my sign-off) is
> 	    maintained indefinitely and may be redistributed consistent with
> 	    this project or the open source license(s) involved.
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
