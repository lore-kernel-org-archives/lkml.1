Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZBZAsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZBZAsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZBZAsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:48:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZBZAsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:48:17 -0500
Message-ID: <49A5E72C.1080804@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 08:49:48 +0800
From: Yang Hongyang <yanghy@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Yang Hongyang <imhy.yang@gmail.com>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
       mtk.manpages@gmail.com, rdunlap@xenotime.net
Subject: Re: Documentation:Update the INDEX of the documents
References: <49A4F06B.6030205@cn.fujitsu.com> <20090225145950.GJ7064@mit.edu> <a669f14b0902250725j4c21463eqc1b88092486f38ad@mail.gmail.com> <20090225155628.GM7064@mit.edu>
In-Reply-To: <20090225155628.GM7064@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Feb 25, 2009 at 11:25:08PM +0800, Yang Hongyang wrote:
>>> If folks do find the 00-INDEX files useful, my suggestion would be to
>>> make a way of automatically extracting them from the individual files
>>> and/or directories, and then making the 00-INDEX files to be
>>> automatically generated.
>> Sounds like a good idea but How to automatically generate
>>  the summaries then?
> 
> Well, for text files (including subdirectory's 00-INDEX files) we
> could have a convention which is the first line of the file should be
> a (max 60 characters) one-line summary of the file.
> 
> We would probably have to do something special with non-free-form-text
> files, including structured text files like Docbook files.  So it's
> not quite so straightforward, but it should be doable.

Yeah,if we do this one-line summary thing,we still have to go through
all these documents.So why not just update the 00-INDEX and then tell
the authors that will add docs to the kernel do the "00-INDEX work"
 themselves?

> 
>     	     		      	     	       - Ted
> 
> 


-- 
Regards
Yang Hongyang
