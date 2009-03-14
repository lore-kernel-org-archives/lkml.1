Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZCNG7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZCNG7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 02:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZCNG7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 02:59:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:13634 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZCNG67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 02:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XagxdRbFpUWdQstaP/485P4jJWTiTuxNL1kNqolcrz3shuZSNDshZFH5FS+osXWSki
         l21qPkgL3D/JwwYCdGt+j7MwiK0TJ+pEvbhAHYHTLwqFMa356hjEQcqulap3VPM0+oil
         nAyN0gkVDPbYIoSTqZfwtdj68aOqCrRJSGZ54=
MIME-Version: 1.0
In-Reply-To: <804dabb00903132107k10fe11efo1622877d4a535500@mail.gmail.com>
References: <804dabb00903132101o6bf812c1r1efd02d069b5c7fa@mail.gmail.com>
	 <804dabb00903132107k10fe11efo1622877d4a535500@mail.gmail.com>
Date: Sat, 14 Mar 2009 14:58:57 +0800
Message-ID: <804dabb00903132358l2b9467e8l2aec01de21c8dbf8@mail.gmail.com>
Subject: Re: [PATCH] replace kernel_thread() with kthread_run() in RT2870
From: Peter Teoh <htmldeveloper@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Greg,

I overlooked some more changes needed.   Will resend later again.
And the original code owner "Paul Lin" does not have the  right email
as well, so I am not sure who can check on the hardware aspect.
THanks.

On Sat, Mar 14, 2009 at 12:07 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Sorry, mixed up the patches with another patch.   Here is the correct
> one.   Thanks.
>
>
> On Sat, Mar 14, 2009 at 12:01 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>> As advised by Greg KH:
>>
>> http://lkml.org/lkml/2009/3/13/131
>>
>> Replaced the usage of kernel_thread() with kthread_run().   Compiled
>> successfully, but not tested as I don't have the hardware.
>>
>> (parsed by scripts/checkpatch.pl as well).
>>
>> Thanks.
>>
>> --
>> Regards,
>> Peter Teoh
>>
>
>
>
> --
> Regards,
> Peter Teoh
>



-- 
Regards,
Peter Teoh
