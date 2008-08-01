Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYHASQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYHASQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYHASQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:16:37 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:22951 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYHASQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=nKBmFoXDTYqLOJVDdGTWmqeFE+qEI6UixPvoGuVRhcZVPaHR0zZr9K/hSLUCjhDVjf
         E0lblVZkDSy51SJx1dOMIjkGEQld/DRX6NWtVLihTL94iDkUGaRiYxKOnDI3aJGzbt8K
         jaOSxF4w0z/cJEXM8/fHD/0dCKUwjet6/roVM=
Message-ID: <489352D8.2020700@gmail.com>
Date: Fri, 01 Aug 2008 14:15:52 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Ryan Hope <rmh3093@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, edward.shishkin@gmail.com
Subject: Re: reiser4 for 2.6.27-rc1
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com> <20080801162548.GD8654@mit.edu> <48f7fe350808010934k32b9de09we657e57087a3e3a5@mail.gmail.com> <20080801164541.GF8654@mit.edu>
In-Reply-To: <20080801164541.GF8654@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Aug 01, 2008 at 12:34:53PM -0400, Ryan Hope wrote:
>   
>> Hmmm, removing the plugin support might not be so hard....  I might
>> have to try this... I am not impressed with btrfs yet.
>>     
>
> Well, if you're going to work on reiser4 (and I think there were other
> people who had also expressed interest/plans to work on it; you might
> try doing a search on the various mailing lists so you can coordinate
> with them and avoid duplicating work), my suggestion to you would be
> to find the comments that were made by the reviewers way back when,
> and make sure those comments have been addressed.
>
> Then, re-requests a code review, and promise that you won't abuse, and
> insult the integrity and impugn the motivations of the reviewers like
> Hans did, and hopefully after they review the code, fix those problems
> as well.  Then you can try resubmitting for inclusion.
>
> Best regards,
>
>     	      	    	 	    	      - Ted
>   

My most up to date information is that Edward is still actively working 
on reiser4....

ric

