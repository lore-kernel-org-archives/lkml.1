Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYBUGJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYBUGJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYBUGI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:08:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:36649 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYBUGI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:08:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KPzmMnrumAuQvdQbstUgRRj8Ermfm5txLiToDIZmHEKZLw9eBAWKGv8fe/JmpC+z67efYJ1RPl3ENGFx5ULTytinFa18gihB7t10VCXSQnL8+Hw6j47FwJmt2UOD8WqSHKY3JCmKsy1/6gEip+QsrVbWv6d4xaAHorQfCiT8tYs=
Message-ID: <47BD1574.9020705@gmail.com>
Date: Thu, 21 Feb 2008 07:08:52 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs: removing unused fops from struct char_device_struct
References: <47BC9433.8020905@gmail.com> <20080221001535.GA23986@kroah.com>
In-Reply-To: <20080221001535.GA23986@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, sorry... for some reason I though you were the guy :)
I'll resend

jirka


Greg KH wrote:
> On Wed, Feb 20, 2008 at 09:57:23PM +0100, Jiri Olsa wrote:
>> Hi,
>>
>> seems struct char_device_struct::fops is no longer used, removing it.
>> I checked with "make allyesconfig" and got proper compile.
>>
>> Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
> 
> Hm, why send this to me?
> 
> Did I make the mistake of touching this file last?  Hm, nope, someone
> else touched it after I did, I'm safe :)
> 
> Seriously, I have no problem with this, but it should probably go
> through Andrew.
> 
> thanks,
> 
> greg k-h
> 

