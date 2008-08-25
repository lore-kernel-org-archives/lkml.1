Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYHYHI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYHYHI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYHYHIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:08:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58192 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYHYHIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QVzNOxzrr1X7Km38+O5VamzezISM+NPrdHgbXv708XIwqGI93AeYWJ8H5KTHIZ9eG5
         uV2C13PYdxv//BTf8bloeqAGQhIUBT2z4jeQNKREtG+6pvR4lDgsf5XIdH3YLryT2l6q
         jPZgmxWRQgUuFF+u6PRxJn9XETyLyh4zKakrM=
Message-ID: <dd18b0c30808250008t342fad9fr1a54a0662473a38@mail.gmail.com>
Date: Mon, 25 Aug 2008 00:08:49 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: converting appletouch to usb autosuspend again...
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808250840.06477.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30808242122h5b6dfc15tf86622595bd46461@mail.gmail.com>
	 <200808250840.06477.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 11:40 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag 25 August 2008 06:22:45 schrieb Justin Mattock:
>> I've notice when letting the system rest for a few and then tapping the
>> touchpad I see this in dmesg:
>> appletouch: 17" model detected.
>> could this be suspend working?
>
> Yes.
>
>> As for appletouch surving suspend
>> I't seems to work i.g.
>> one tap, two tap, side scroll,
>
> Good.
>
>> although with the latest git
>> and the latest update from sid(of xserver);
>> I'm not seeing these functions work....
>
> Please post logs. Without logs nobody can help you.
>
>        Regards
>                Oliver
>

Alright; as for the appletouch
not working upon wakeup, I just tried it to see,
and it is working...(can't explain why it wasn't, maybe a quirk somwhere);
Although; I am receiving an error, so maybe this has something to
do with it(heres the thread):
http://marc.info/?l=linux-kernel&m=121926203029380&q=raw
from what I remember I issued echo mem > /sys/power/state
and then left the laptop in sleep for a few hours.
Anyways I'll try and grab as much logs as possible.
and thanks for the info and help.

regards;

-- 
Justin P. Mattock
