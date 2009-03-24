Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZCXWBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZCXWBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZCXWBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:01:45 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:49433 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZCXWBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=XxrWpn4pjolu9rugyjBtpbBEW6xm/KdmTrn3GPA49jHf1ThIU9sxrvGWGidwTA6dSP
         fQkjpwAYCcyccRQVcqsDwR9fZgG15g4ij9Npu+GWN1sU3qCSaDkw8VvNyTWP/5rVYmAo
         qj69eb/evaHhFP6iZjs0lbLiS/PRrWr4bWlCM=
Message-ID: <49C95842.9030407@gmail.com>
Date: Tue, 24 Mar 2009 23:01:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: one more tty reference leak [Was: 2.6.30 -mm merge plans]
References: <20090323224615.cd29edfd.akpm@linux-foundation.org> <49C9552B.1090701@gmail.com>
In-Reply-To: <49C9552B.1090701@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.3.2009 22:48, Jiri Slaby napsal(a):
> On 24.3.2009 06:46, Andrew Morton wrote:
>> isicom-isicom-kref-leak-fix.patch
>> isicom-isicom-kref-leak-fix-fix.patch
> ...
>> Merge, backport to 2.6.29.x
>
> Could you (or Alan) also pick
> http://lkml.org/lkml/2009/3/16/159
> up and merge?

Ignore me, Alan already did, the patch 26/30 from 'Serial and tty for 
2.6.30'.
