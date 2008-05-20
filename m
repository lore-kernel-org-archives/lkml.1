Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYETAEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYETAEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYETAEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:04:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:50956 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbYETAEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:04:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PGmwO7+A7yJRlOOs4+cAhzGy6P9ukYKPu42R76QWhTrzKg8K/cAZsm1a8/iW/kLMfGP9LeEZTCnaY1vnIKYNCa2JgmZh141Pn7ITXw4QlBP5rfYu3L8B96Z331EwJPcODhzYAiS5zfkWcmgKG7riCve/PLC5K9sp4xGB5x0wHuo=
Message-ID: <9a8748490805191704n45a738a2l40af576b132945ec@mail.gmail.com>
Date: Tue, 20 May 2008 02:04:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jike Song" <albcamus@gmail.com>
Subject: Re: [PATCH] fix typo "kernal" -> "kernel"
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <df9815e70804240156x70e7b548ydfedf496db9442e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1209026537-30611-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
	 <df9815e70804240156x70e7b548ydfedf496db9442e8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/24 Jike Song <albcamus@gmail.com>:
> seems to be the same. To be pedantic,
>
> http://en.wikipedia.org/wiki/KERNAL
>
<snip>

None the less I've added the patch to Trivial. It's the Linux *kernel*
after all, not the Linux kernal.

/Jesper

>
>
> On Thu, Apr 24, 2008 at 4:42 PM, Uwe Kleine-König
> <Uwe.Kleine-Koenig@digi.com> wrote:
>> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
>>  Cc: trivial@kernel.org
>>  ---
>>   fs/proc/nommu.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>  diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
>>  index 941e951..618a732 100644
>>  --- a/fs/proc/nommu.c
>>  +++ b/fs/proc/nommu.c
>>  @@ -76,7 +76,7 @@ int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
>>
>>   /*
>>   * display a list of all the VMAs the kernel knows about
>>  - * - nommu kernals have a single flat list
>>  + * - nommu kernels have a single flat list
>>   */
>>   static int nommu_vma_list_show(struct seq_file *m, void *v)
>>   {
>>  --
>>  1.5.5.1
>>
>>  --
>>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>  the body of a message to majordomo@vger.kernel.org
>>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>  Please read the FAQ at  http://www.tux.org/lkml/
>>
>



-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
