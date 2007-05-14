Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXENDkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXENDkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXENDkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:40:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:55875 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXENDkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ldt4rInryBlrdeI6P/2WsWoqPAhrkoFrQihpOf35GgsngJlheh+vt+kzOy4CyayjD/VIJGgqx+E0xs3B7UXy3kbiy+GvsJ7vkY50oUJOJEYNRFaBJVd2qCwJtgCfgL23gl5LvtbuDfxlH7/ZMPKf2guWAEuvAXE1ynn9bStcAn4=
Message-ID: <a781481a0705132040u1c4047f0xf953ccd13f622684@mail.gmail.com>
Date: Mon, 14 May 2007 09:10:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, rlove@rlove.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200705132257.07257.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070512002115.GZ11166@waste.org>
	 <200705120112.52859.dtor@insightbb.com>
	 <a781481a0705112245u356759dcm9a550e432ed178fd@mail.gmail.com>
	 <200705132257.07257.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> Hi Satyam,
>
> On Saturday 12 May 2007 01:45, Satyam Sharma wrote:
> > Seems to be good-looking code!
>
> Thanks. Do you have the hardware? Were you able to test the patch?

Oh, sorry, no. I was actually referring to the input-polldev code. Let's
hope Matt can test and ack this.

Thanks,
Satyam
