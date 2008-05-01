Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbYEAKHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbYEAKHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYEAKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:07:20 -0400
Received: from bay0-omc1-s34.bay0.hotmail.com ([65.54.246.106]:2414 "EHLO
	bay0-omc1-s34.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbYEAKHT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:07:19 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 06:07:19 EDT
Message-ID: <BAY109-W48804E374E627015B2B5279BDB0@phx.gbl>
X-Originating-IP: [15.203.169.126]
From: Joe Fegan <joe_fegan@hotmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Subject: RE: [PATCH] ext3: Fix typos in messages and comments (journalled ->
 journaled)
Date: Thu, 1 May 2008 11:01:08 +0100
Importance: Normal
In-Reply-To: <20080501002018.2729adcc@core>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
 	<12095679812452-git-send-email-jack@suse.cz>
 	<1209567981639-git-send-email-jack@suse.cz>
 	<20080430104330.66c44d4f.akpm@linux-foundation.org>
 	<20080430212711.168bdcc0@core>
 	<1209592973.6113.23.camel@norville.austin.ibm.com> 
 <20080501002018.2729adcc@core>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 01 May 2008 10:01:08.0898 (UTC) FILETIME=[472F9020:01C8AB72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Then again, I would consider journalize to be the US version of journalise

> Date: Thu, 1 May 2008 00:20:18 +0100
> From: alan@lxorguk.ukuu.org.uk
> To: shaggy@linux.vnet.ibm.com
> CC: akpm@linux-foundation.org; jack@suse.cz; linux-kernel@vger.kernel.org; linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled -> journaled)
>
>>> A search of the ACM literature finds "journalized", "journalled" and
>>> "journaled" are all in use for this operation.
>>
>> I hate to get into these discussions, but I've used "journaled" a lot,
>> so I feel I should chime in.
>
> I noticed and IBM cannot even agree internally 8)
>
> "Tivoli Storage Manager Journal Based Backup troubleshooting techniques
> and solutions to common problems seen with journalized backups and the
> journal database. This is from a 2005_November_07 Support Technical
> Exchange Web seminar presented by TSM Support staff"
>
> "IBM Journaled File System (JFS)"
>
>
>> That would probably be more correct, but the use of "journal" as a verb
>> has really gotten ingrained in file system developers brains. I
>> personally haven't heard or used "journalized" and it would take some
>> getting used to.
>
> Mandrake use Journalized File System in various press articles. Mac
> people seem to like journalized too and google shows it used in various
> reviews and articles.
>
> I think I'm going to follow this up with the professional bodies and see
> if there is an opinion because either the computing world needs to agree
> on a proper English name, or they need to agree on a new one and talk to
> the dictionary people about it.
>
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Windows Live Spaces – your life, your Space. Click here to find out more.
http://get.live.com/spaces/overview