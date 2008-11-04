Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYKDK3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYKDK3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYKDK2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:28:54 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:16572 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYKDK2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ixru3jSFI8x2cFq6Ckf5aC+Y5JWHKeWHYw0h5u4r1vvdFudrk6kyqqMvy2T4wRsGh7
         DtjqC2nUm6AdqJ4BhfSso5OsTZTmQ0KjThM0DV7t8ctkKIJKWXaS1s1ZdJ/bfE2P3EQO
         aeNCMqMwW9r/0xgKzCivXNWnfYelGchG6e1uk=
Message-ID: <c41302d20811040228y23ce963fh39c27f79cb7711df@mail.gmail.com>
Date: Tue, 4 Nov 2008 12:28:47 +0200
From: "Avishay Traeger" <avishay@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [osd-dev] [RFC 0/9] osdfs
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49101FE2.30109@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4909C41A.7000406@panasas.com> <490F6829.3020104@garzik.org>
	 <49100213.6040307@panasas.com> <49101FE2.30109@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 12:11 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:

<snip>

>>> As such, "osdfs" seems like too-generic a name. How about boazfs?  :)
>>
>> I agree.  osdfs is the name given by Avishay and IBM and we just adopted it.
>> I think that obfs (Object-based File System) would better represent
>> what it is (although it's still generic compared to boazfs :-)
>>
>
> If at all then it's avishayfs, but unless I write this filesystem from
> scratch I don't think I can do anything about the name. The code is
> copyrighted to Avishay Traeger, and that is the name he chose. Also
> he has a sourceforge.net project of that name for a long time.
>
> Avishay would you be willing to change the name? See above, people
> think it is too generic a name. Like if someone would do a scsifs
> or blocksfs.
>
> Personally for me it's just a name, I don't mind either way.

I don't care if we change the name.  I suppose we can discuss
alternatives outside of the mailing lists, but I'd rather not do
boazfs or avishayfs :-)

By the way, just to clarify: I wrote this file system at IBM, but they
were nice enough to give me full ownership of the code.  I then
proceeded to put the code up on sourceforge.  Thanks to Boaz and Benny
for reviving the code and submitting it for inclusion in the kernel.

Avishay
