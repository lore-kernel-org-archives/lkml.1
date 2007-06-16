Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXFPSsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXFPSsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 14:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXFPSsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 14:48:12 -0400
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:56169 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXFPSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 14:48:11 -0400
Message-ID: <46744225.7000609@wolfmountaingroup.com>
Date: Sat, 16 Jun 2007 14:03:49 -0600
From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) Gecko/20050513 Fedora/1.7.8-2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Harkes <jaharkes@cs.cmu.edu>
CC: Jack Stone <jack@hawkeye.stone.uk.eu.org>, alan <alan@clueserver.org>,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <46739B2C.4080606@hawkeye.stone.uk.eu.org> <4673B15B.2080300@wolfmountaingroup.com> <4673B77E.1000803@wolfmountaingroup.com> <20070616164931.GF14788@delft.aura.cs.cmu.edu>
In-Reply-To: <20070616164931.GF14788@delft.aura.cs.cmu.edu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Harkes wrote:

>On Sat, Jun 16, 2007 at 04:12:14AM -0600, Jeffrey V. Merkey wrote:
>  
>
>>Jeffrey V. Merkey wrote:
>>    
>>
>>>over).  There's also another patent filed as well.  It's a noble 
>>>effort to do a free version, but be aware there's some big guns with 
>>>patents out there already, not to mention doing this is complex beyond 
>>>belief.
>>>      
>>>
>>I reviewed your sample implementation, and it appears to infringe 3 
>>patents already.    You should do some research on this.  ~~~~
>>    
>>
>
>First of all, you are responding to someone in the UK, I thought they
>didn't even have software patents over there. Second, I didn't see any
>implementation, just a high level description. Finally advising anyone
>(who is not an actual patent lawyer that could correctly interpret the
>language and scope of a patent) to go search out patents seems pretty
>bad advice. That can only result in not even attempting to research some
>potentially new and innovative approach.
>
>Researching prior published work in the area is considerably more
>helpful. Especially when something is complex beyond belief it has
>probably attracted various researchers over time and there are most
>likely various different solutions that have been explored previously.
>Such existing work can form a good basis for further work.
>
>Finally, even if there are patents they could be too limited in scope,
>overly broad, can be invalidated due to prior art. It may also be
>possible that a patent holder has no problem granting a royalty free
>license for a GPL licensed implementation.
>
>Jan
>
>
>  
>
When you get into the recycling issues with storage, the patents come 
into play. Also, using the file name to reference revisions is already 
the subject of a patent previously filed (I no longer own the patent, I 
sold them to Canopy). There is a third one about to be issued.

The patents are:
*
6,862,609
**6,795,895

and this one about to be issued:

http://www.wipo.int/pctdb/en/fetch.jsp?LANG=ENG&DBSELECT=PCT&SERVER_TYPE=19&SORT=1211506-KEY&TYPE_FIELD=256&IDB=0&IDOC=1205953&C=10&ELEMENT_SET=IA,WO,TTL-EN&RESULT=1&TOTAL=3&START=1&DISP=25&FORM=SEP-0/HITNUM,B-ENG,DP,MC,PA,ABSUM-ENG&SEARCH_IA=US2005045566&QUERY=%28IN%2fmerkey%29+

The last one was filed with WIPO and has international protection, UK 
included.

Jeff

*

Jeff
