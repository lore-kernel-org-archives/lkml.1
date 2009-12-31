Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZLaQpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZLaQpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 11:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZLaQpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 11:45:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:17632 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZLaQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 11:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YLRTNeNV3fJztZB68cGUYkEpV399rvMEf6en7kA8xiIx/8Vdf4zAwetCPRhN+k7Fh9
         zUcDiEnkdAa9Xqnmb/LTKraDU/G0i3y0YORv5HggMOArFirmZjTT5KS9ICbF3Mrk5TCM
         SjwA1zkle5Beiw2goaBi9ocgx08d2WzvrZfiA=
MIME-Version: 1.0
In-Reply-To: <20091231173719.6fee3a68@destiny.ordissimo>
References: <2d0a357f0912310817p3b828239qc81994973fca1274@mail.gmail.com>
	 <20091231173719.6fee3a68@destiny.ordissimo>
Date: Thu, 31 Dec 2009 17:44:59 +0100
Message-ID: <2d0a357f0912310844j7b46b593vc6f6c944248f3014@mail.gmail.com>
Subject: Re: [2.6.33{rc2-git1,2}]: hp-wmi again broken
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Anisse Astier <anisse@astier.eu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

On Thu, Dec 31, 2009 at 5:37 PM, Anisse Astier <anisse@astier.eu> wrote:
> Hi Sedat,
>
> On Thu, 31 Dec 2009 17:17:43 +0100, Sedat Dilek <sedat.dilek@googlemail.com> wrote :
>
>> Hi,
>>
>> I am not sure why this bug has re-entered from linux-acpi-2.6 to
>> linux-kernel, but I just wanted to report Anisse has re-send a fix for
>> hp-wmi [1].
>> The original bug was reported with appended patch in [2].
>> From 2.6.33-rc2 to 2.6.32-git2 hp-wmi is still broken.
>> Please, fix that cleanly in upstream, now.
>> Thanks.
>>
>> Kind Regards,
>> - Sedat -
>>
>> [1] ACPI & driver patches for 2.6.33-rc2
>> http://patchwork.kernel.org/patch/70398/
>> [2] [2.6.33-rc2] ACPI problems on HP nc6400 notebook
>> http://patchwork.kernel.org/patch/69745/
>
> It would be nice if you could test the patch I sent, so that we had a
> confirmation it's working. It's a (trivial)one-liner, but it was also a
> one-liner that introduced the regression.
>
> Thanks in advance.
>
> Anisse
>
>
