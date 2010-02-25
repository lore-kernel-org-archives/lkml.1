Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0BYAoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 19:44:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57471 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab0BYAoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 19:44:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SwNjGG2ByrS0/nhoAunAs/zYhu35l7ql8AEJbYRoG3OlqOkJ0jT6KcXsWQNI1arfFC
         UlVvPjfqwOixJ65YzGlWqyl0zqnV06CP2q3X7ERvpaGPdELl1bX1V9omf3EKNknkNKm6
         sBJ534h32CRd11vV9sW3YuhdkO35HhCF1WOKg=
MIME-Version: 1.0
In-Reply-To: <4B85C59C.3010602@free.fr>
References: <43e72e891002241618w10d5c45ar9303f074d0228217@mail.gmail.com> 
	<4B85C59C.3010602@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Feb 2010 16:43:45 -0800
Message-ID: <43e72e891002241643o3ba0b0bp5c7b90a6ae6680ec@mail.gmail.com>
Subject: Re: 802.11 development process - extended documentation
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 4:34 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> Luis R. Rodriguez a écrit :
>>
>> I've extended our 802.11 development process into a new section on our
>> 802.11 wiki. I often get asked how this works from different parts of
>> the company here at Atheros so figured it'd be easier to illustrate
>> this as best as possible and share it.
>>
>> http://wireless.kernel.org/en/developers/process
>>
>> Hope it does justice, John if you see any mistakes feel free to edit.
>> If the diagram seems fishy let me know what I can fix.
>>
>>  Luis
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> Nice (especially the picture)! However, Johannes has its picture in the
> text, but not in the diagram and the opposite for ... you I guess (picture
> on the left hand).

I figured I'd throw in the compat-wireless stuff while at it as I have
to explain that as well often. I didn't yet get to add text for the
compat stuff.

Johannes has no tree so there is no tree to show on the diagram on the process.

> Just a quick review. I still need to fully understand the
> "patch" stream...

Let me know if this helps or if there are things we can do the help
clarify this more.

  Luis
