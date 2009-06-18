Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbZFROB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbZFROB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbZFROBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:01:50 -0400
Received: from mail-yx0-f186.google.com ([209.85.210.186]:43451 "EHLO
	mail-yx0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbZFROBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:01:49 -0400
X-Greylist: delayed 43493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 10:01:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fdEeY04KI5lnrt8kt795+3j0iLTaab9kCWE1CNJGRO5YS2dKibOG2HO43S3mw2DN0U
         4zyI5SWJEOMrk2ci2iBcyvXJKAp/lWRYH03jxKCkvhI9yYcq7NV6jaEIKowseUKMLUz3
         gOvmrGfTshA+ixVkb+TDio0eClIXyzTS3IDng=
MIME-Version: 1.0
In-Reply-To: <a55d774e0906171944x7d96c20dhb5c29e8ce2c6772b@mail.gmail.com>
References: <1245285075-20022-1-git-send-email-swetland@google.com>
	 <1245285075-20022-2-git-send-email-swetland@google.com>
	 <1245285075-20022-3-git-send-email-swetland@google.com>
	 <1245285075-20022-4-git-send-email-swetland@google.com>
	 <49b7c2350906171856n4f7f7ca8u5f5302be2b4ae8a9@mail.gmail.com>
	 <a55d774e0906171944x7d96c20dhb5c29e8ce2c6772b@mail.gmail.com>
Date: Thu, 18 Jun 2009 23:01:51 +0900
Message-ID: <49b7c2350906180701j35b3ac4do11f8a999dadccf31@mail.gmail.com>
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream 
	device
From: GeunSik Lim <leemgs1@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 11:44 AM, Brian Swetland<swetland@google.com> wrote:
> On Wed, Jun 17, 2009 at 6:56 PM, GeunSik Lim<leemgs1@gmail.com> wrote:
>> On Thu, Jun 18, 2009 at 9:31 AM, Brian Swetland<swetland@google.com> wrote:
>>> This is just enough to get the device booting and serial console
>>> working.  Sufficient for debugging further MSM7k/Dream Support.
>>> This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
>>> are all the same hardware, known as "trout" to the ARM machine
>>> database).
>> Hi Brian,
>> I have one silly question.
>> I still not understand "trout" meaning with your description.
>>
>>> +config MACH_TROUT
>>> +       default y
>>> +       bool "HTC Dream (aka trout)"
>>> +       help
>>> +         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>>> +
>> "trout" word just means HTC Dream Model. Is it right?
>
> Yes -- this is the ARM linux kernel machine ID for this hardware:
> http://www.arm.linux.org.uk/developer/machines/list.php?id=1440
>
> Brian
>
Looks good to me.
Reviewed-by: GeunSik Lim <geunsik.lim@samsung.com>


-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
