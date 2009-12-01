Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZLAXuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZLAXuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZLAXuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:50:18 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:36306 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZLAXuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OtSDyQj2A/s7KzuNp8vB21A872+I8sTWX8v69xDqaXtUw6CJwYy7dRiGhN9PInsiPo
         WJNxpTY0AKdiQ3UmWxbqoUXLyvzFTUWZ1SSg4WWsoH6+2S2qg+baka5MbWaLCBCW0ikO
         zuRgoeXqQZCjfVc3WqZkTqtc+1eqnArSHdjEU=
Message-ID: <4B15ABBE.90101@gmail.com>
Date: Tue, 01 Dec 2009 15:50:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Kernel BUG during suspend to disk with 2.6.32-rc8-git3
References: <4B159EAC.1010006@lwfinger.net> <4B15A2F6.4020206@gmail.com> <4B15A9FB.2030808@lwfinger.net>
In-Reply-To: <4B15A9FB.2030808@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/09 15:42, Larry Finger wrote:
> On 12/01/2009 05:12 PM, Justin P. Mattock wrote:
>>
>>
>> looks familiar with what I'm getting
>> over here.
>> bugreport: http://bugzilla.kernel.org/show_bug.cgi?id= 14483
>>
>> at the bottom reverting that commit
>> worked here(but still need to see
>> what others say).
>
> Reverting commit 138d15692bf76841f252d4b836a535cf5f9154e9 fixed the
> problem on my computer. Thanks for the info.
>
> Larry
>
>

cool,
finally some kind of handle
on this. Now I guess the
best thing todo now is to
wait and see what the acpi guys have
to say.

Justin P. Mattock

