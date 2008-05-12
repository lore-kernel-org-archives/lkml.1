Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYELLjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYELLjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYELLjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:39:25 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39314 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYELLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:39:24 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: jclyXLBJ10ZHTmMMskdeEV9K+qamm4K24+0GzTHYHnheuzKtvddXf0sc+CAlfN0=
Message-ID: <48282C69.2070006@hartkopp.net>
Date: Mon, 12 May 2008 13:39:21 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com>	 <48198873.7030503@hartkopp.net>  <481A06C0.6070500@zytor.com> <1210163964.14371.1.camel@localhost>
In-Reply-To: <1210163964.14371.1.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti wrote:
> On Thu, 2008-05-01 at 11:06 -0700, H. Peter Anvin wrote:
>
>   
>> Most of the robots don't have access to git.
>>
>>     
>>> For me a 2.6.25-gitX looks like a snapshot that leads to a 2.6.25.1 and 
>>> _not_ to a 2.6.26-rc1.
>>>       
>> Tough.  It's a naming convention quite old (we had -bk before -git, too.)
>>     
>
> What about a -rc0 as the first commit after a release? Will help a lot
> automatic installing scripts...
>
>   

Yes - this was also my intention. I don't have any preferences if the 
first commit after a release is named -merge or -rc0. But it should 
point out that we're leaving the former stable release.

Regards,
Oliver

