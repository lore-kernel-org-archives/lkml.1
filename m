Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbYGVINv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbYGVINv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYGVINg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:13:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:32033 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYGVINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=evaBXoLBRhFxM9fmTBped3/R9yhUSvyL/p2XJdga9+4W916R+zZ+TU4MchufOZyErD
         wr/xCWnmtaQDYE6+9sudDcIZHQuf3U4FlVOrD1g8tm2zRdcT5WvRg5zhq5uHtt36YNBY
         6e8JZfQLblnTYTy0NDZ8ebhK+c+Cy3AiUSB2c=
Message-ID: <86802c440807220113n11f1e5ffuad6bde2f6b20c996@mail.gmail.com>
Date: Tue, 22 Jul 2008 01:13:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] lguest: set max_pfn_mapped, growl loudly at Yinghai Lu
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200807221806.32852.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807221806.32852.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 1:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> 6af61a7614a306fe882a0c2b4ddc63b65aa66efc 'x86: clean up max_pfn_mapped
> usage - 32-bit' makes the following comment:
>
>    XEN PV and lguest may need to assign max_pfn_mapped too.
>
> But no CC.  Yinghai, wasting fellow developers' time is a VERY bad
> habit.  If you do it again, I will hunt you down and try to extract
> the three hours of my life I just lost :)

sorry for that. will put you on the cc list.

BTW, hope you can spend some time to check tip/master like jeremy for xen pv.

YH
