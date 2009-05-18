Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZERGyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZERGyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZERGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:53:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:32798 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZERGxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eKrgNMXOvgANdQWVZKNuu24gvDbkubm3rK/ym11jQj232Fyf9RAC6sw0yAb41BsHtq
         NhGbfdPvPNYQB+aAbQupFkIisQC8nHj6y9meOwF6tJ5gZhpl1vuPEOqOZ68Yyvpx9kul
         Vk3kki0IP1tZJ/umZKlkVJNkoZU7avaky+qH4=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
References: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
	 <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
Date: Mon, 18 May 2009 12:23:48 +0530
Message-ID: <108af1800905172353g5692d340g1c389fbec7116c10@mail.gmail.com>
Subject: Re: [PATCH] Spelling fix in btrfs code comment
From: Sankar P <sankar.curiosity@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 9:16 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 9 May 2009, Sankar P wrote:
>
>> Fix a trivial spelling error in a comment
>>
>> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
>>
>> ---
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e496644..3e2c7c7 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
>>  }
>>
>>  /*
>> - * return the block group that contains teh given bytenr
>> + * return the block group that contains the given bytenr
>>   */
>>  struct btrfs_block_group_cache *btrfs_lookup_block_group(
>>                                                struct btrfs_fs_info *info,
>
> Appplied to trivial tree. If it has been already applied to btrfs pileup,
> please let me know so that I could drop it.

This is now available in the btrfs tree and Linus' tree. Thanks.

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>

--
Sankar
