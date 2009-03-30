Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZC3Gjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZC3Gjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZC3Gji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:39:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:18956 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZC3Gji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:39:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v1zHrz/T5/op1J3ztEzdldlhKpzANgzkRIzTo36Vinc24W/NzkZVrW+yJTG4DuWuQ4
         mldE5ktdj/vU/Pvt9xhdRJfPkPwplKHd0hEd492Y0XN2j9Iias7Ev68mYSKcIvptpbNo
         RHmXlaAaGbAefTK5S9VbZGPLa/bRptE0ghjQ0=
MIME-Version: 1.0
In-Reply-To: <87tz5e6mb3.fsf@basil.nowhere.org>
References: <a8e1da0903272335scc5ee66sdaaa170d982dc116@mail.gmail.com>
	 <87tz5e6mb3.fsf@basil.nowhere.org>
Date: Mon, 30 Mar 2009 14:39:36 +0800
Message-ID: <a8e1da0903292339o7e4c564es1518d4ee2cb299cb@mail.gmail.com>
Subject: Re: Clocksource tsc unstable
From: Dave Young <hidave.darkstar@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 5:14 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dave Young <hidave.darkstar@gmail.com> writes:
>
>> Hi,
>>
>> My laptop is dell e5400 with  intel core 2 duo 7250, kernel version
>> 2.6.29, dmesg report tsc unstable, anyone can help to see?
>
> It's expected behaviour for core 2 duo with C3 states.

Thanks.

>
> -Andi
>
>



-- 
Regards
dave
