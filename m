Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZKMQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZKMQTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZKMQTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:19:44 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45803 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZKMQTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:19:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vEmJN2kN57prX0uc3AicvQ1DKVO4R2dITekGm7QdTnfhCjxJSCMejyyQwGZsiOrsKW
         Kp0rFkcB9qYQsKpM2tg/kNwasuDCYL8T36BwgYUT7zBn0169Fg/ZEsAnVj29Z83bg8Sj
         FLjOJIKZXwFrsmUxVX40jJlm4Iza6NZ0eST+Q=
MIME-Version: 1.0
In-Reply-To: <51058d550911130206m2982d20dq51bcf943f1ec91c3@mail.gmail.com>
References: <43e72e890911121754p751060b1h1cec7eeb78da8806@mail.gmail.com> 
	<51058d550911130206m2982d20dq51bcf943f1ec91c3@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 08:19:29 -0800
Message-ID: <43e72e890911130819m42c3da2bv4e956c5eed75617c@mail.gmail.com>
Subject: Re: [ANN] Stable compat-wireless 2.6.32-rc7 released
To: Greg Oliver <oliver.greg@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 2:06 AM, Greg Oliver <oliver.greg@gmail.com> wrote:
> On Thu, Nov 12, 2009 at 7:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> Along with the 2.6.32-rc7 comes the stable compat-wireless based [1]
>> on it [2] which allows you to get the 2.6.32-rc7 wireless subsystem
>> and new wireless drivers compilable and installed on older kernels.
>> This is like the general compat-wireless releases but are *stable* and
>> should be *stable*. Please report any issues ASAP. For details on
>> changes you can refer to the ChangeLog-2.6.32-rc7-wireless [3].
>>
>>  Luis
>>
>> [1] http://wireless.kernel.org/en/users/Download/stable
>> [2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32-rc7.tar.bz2
>> [3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/ChangeLog-2.6.32-rc7-wireless
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> The link on kernel.org for rc7 is linked to rc6...  (rc7 does exist
> there though)...

That seems fixed now.

  Luis
