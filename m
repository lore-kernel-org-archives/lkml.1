Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZFRCDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZFRCDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZFRCDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:03:14 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:37549 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZFRCDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wZ0y0Fq45NO/bTzeJ9eKS7V4i/yCZ+7aLdSwY9lLJOwvldUVcy0QgyYZRWRQbV4VpO
         XITdt5Uf8v/alVzargcAmqYK1Yrg0Z4xZxPBdaMjkSjwvmcLWOneK32wlXAFrp0r5qzR
         1kQh74GtEcxzGDNJEFpMBcZvWFlX/ClXjH3R4=
MIME-Version: 1.0
In-Reply-To: <1245285075-20022-4-git-send-email-swetland@google.com>
References: <1245285075-20022-1-git-send-email-swetland@google.com>
	 <1245285075-20022-2-git-send-email-swetland@google.com>
	 <1245285075-20022-3-git-send-email-swetland@google.com>
	 <1245285075-20022-4-git-send-email-swetland@google.com>
Date: Thu, 18 Jun 2009 10:56:57 +0900
Message-ID: <49b7c2350906171856n4f7f7ca8u5f5302be2b4ae8a9@mail.gmail.com>
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

On Thu, Jun 18, 2009 at 9:31 AM, Brian Swetland<swetland@google.com> wrote:
> This is just enough to get the device booting and serial console
> working.  Sufficient for debugging further MSM7k/Dream Support.
> This will support HTC Dream / T-Mobile G1 / Android ADP1 (which
> are all the same hardware, known as "trout" to the ARM machine
> database).
Hi Brian,
I have one silly question.
I still not understand "trout" meaning with your description.

> +config MACH_TROUT
> +       default y
> +       bool "HTC Dream (aka trout)"
> +       help
> +         Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> +
"trout" word just means HTC Dream Model. Is it right?
Thks,

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
