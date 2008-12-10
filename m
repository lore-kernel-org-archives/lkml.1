Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYLJHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYLJHOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYLJHOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:14:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:50579 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbYLJHOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h1TJZ0KAXUS3U/Nm2aWoe+hyTkDxktA5q7WTjgfqaiwegVyYgFMg2KlBuwNDJsybkV
         x+nY4sSK01JngCqNaD/3NvDowu/t8xIXpuB7s55GuWqfFyfeBLiZG5Sy8CvD/n+0BPSZ
         CtqnqeiZ53TIt51EPQICYy42d+vn5oruIeb2s=
Message-ID: <5d5443650812092314s4b51abb2me5e0f16a36d2c18c@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:44:21 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Lauri Leukkunen" <lauri.leukkunen@nokia.com>
Subject: Re: [PATCH] Add TI TSC2005 Touchscreen driver
Cc: "ext Sam Ravnborg" <sam@ravnborg.org>,
       "David Brownell" <david-b@pacbell.net>, dmitry.torokhov@gmail.com,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       linux-input@vger.kernel.org
In-Reply-To: <20081209131705.GC6667@pure.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650812080949h5aff6010mb7341f581841f126@mail.gmail.com>
	 <20081208182648.GA9740@uranus.ravnborg.org>
	 <20081209131705.GC6667@pure.research.nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lauri,

On Tue, Dec 9, 2008 at 6:47 PM, Lauri Leukkunen
<lauri.leukkunen@nokia.com> wrote:
> On 08/12/08 19:26 +0100, ext Sam Ravnborg wrote:
>> > Add Texas Instruments TSC2005 chip touchscreen driver.
>> >
>> > Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
>>
>> Hi Trilok.
>> A few nitpicks below.
>>
>> In general a very clean written driver with adequate comments - nice work!
>
> Umm, isn't this code mostly written by Nokia? At least I remember modifying
> some of it, and this version looks like Konsta Karsisto might be the last
> person touching it. Originally I think it's written by Imre Deak, probably
> based on the tsc2301 code.

Yes, you are the author. Please check first few lines of this patch,
--from field has your name :)

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
