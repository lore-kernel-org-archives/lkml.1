Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYHYOYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYHYOYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYHYOX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:23:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46163 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYHYOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a1f1HkNK9RG7y1PZ7Pf1PS6pt9lUWR5ObzlitqSz0wBm/oH4EBslfuwvzoUyhJVgCn
         ABZA4GZuLDtLrDt0n+VQ2FYAU/7cmiKm94rGNGAE0qVM1UOn+9zkA0YLta31qnTZnkWC
         /t8OExRFNZm4MPBxUzkqcUHUOzwmfXVV2f240=
Message-ID: <dd18b0c30808250723u398614fdv9f8651a96f83d17a@mail.gmail.com>
Date: Mon, 25 Aug 2008 07:23:55 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: converting appletouch to usb autosuspend again...
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808250932.39133.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30808242122h5b6dfc15tf86622595bd46461@mail.gmail.com>
	 <200808250840.06477.oliver@neukum.org>
	 <dd18b0c30808250008t342fad9fr1a54a0662473a38@mail.gmail.com>
	 <200808250932.39133.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:32 AM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag 25 August 2008 09:08:49 schrieb Justin Mattock:
>> Alright; as for the appletouch
>> not working upon wakeup, I just tried it to see,
>> and it is working...(can't explain why it wasn't, maybe a quirk somwhere);
>> Although; I am receiving an error, so maybe this has something to
>> do with it(heres the thread):
>> http://marc.info/?l=linux-kernel&m=121926203029380&q=raw
>
> That's bluetooth. Totally unrelated.
>
> So to summarize: suspend/resume has been tested and works.
> What about autosuspend? Did you test that?
>
>        Regards
>                Oliver
>
>

autosuspend, meaning when leaving the system
idle, then after a few minuetes tapping the touchpad!
if this is what you are referring to, then yes I see appletouch working
in that area, but if there is something else I'm missing, then yeah I
can look into
it and see what I find.


-- 
Justin P. Mattock
