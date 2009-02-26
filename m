Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBZAxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBZAxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbZBZAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:52:50 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:17911 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZBZAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:52:49 -0500
Message-ID: <49A5E7CA.8020905@oracle.com>
Date: Wed, 25 Feb 2009 16:52:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yang Hongyang <yanghy@cn.fujitsu.com>
CC: Theodore Tso <tytso@mit.edu>, Yang Hongyang <imhy.yang@gmail.com>,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-doc@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: Documentation:Update the INDEX of the documents
References: <49A4F06B.6030205@cn.fujitsu.com> <20090225145950.GJ7064@mit.edu> <a669f14b0902250725j4c21463eqc1b88092486f38ad@mail.gmail.com> <20090225155628.GM7064@mit.edu> <49A5E72C.1080804@cn.fujitsu.com>
In-Reply-To: <49A5E72C.1080804@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49A5E783.010C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yang Hongyang wrote:
> Theodore Tso wrote:
>> On Wed, Feb 25, 2009 at 11:25:08PM +0800, Yang Hongyang wrote:
>>>> If folks do find the 00-INDEX files useful, my suggestion would be to
>>>> make a way of automatically extracting them from the individual files
>>>> and/or directories, and then making the 00-INDEX files to be
>>>> automatically generated.
>>> Sounds like a good idea but How to automatically generate
>>>  the summaries then?
>> Well, for text files (including subdirectory's 00-INDEX files) we
>> could have a convention which is the first line of the file should be
>> a (max 60 characters) one-line summary of the file.
>>
>> We would probably have to do something special with non-free-form-text
>> files, including structured text files like Docbook files.  So it's
>> not quite so straightforward, but it should be doable.
> 
> Yeah,if we do this one-line summary thing,we still have to go through
> all these documents.So why not just update the 00-INDEX and then tell
> the authors that will add docs to the kernel do the "00-INDEX work"
>  themselves?

I doubt that the 00-INDEX files are that useful...


-- 
~Randy
