Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbXEWOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbXEWOht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbXEWOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 10:37:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:14728 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbXEWOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 10:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CDhXEtZtSBpvlW+8jbkuosLHjwTlDJl/zz+QZLCUSfHEJGJhfEwO10xZh7YBBwtlwDVRgMT3oKvKn3eyNsqWPlduM9k5/KSeJToYL0yOGeliVwiu/aFbyBAIqwhWVR1HVXVJl6Sz6TGu860EHFaXwj/6rP/udm9NM0OXq9fZQPs=
Message-ID: <d120d5000705230737s40d92df7m91a7b574e3a9c0d1@mail.gmail.com>
Date: Wed, 23 May 2007 10:37:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [PATCH] joydev.c automatic re-calibration
Cc: "Renato Golin" <rengolin@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
	 <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/23/07, Jiri Kosina <jikos@jikos.cz> wrote:
> (Adding Dmitry to CC so that he doesn't miss it.
>
> Also, if you'd like to get your patch merged, you should add proper
> Signed-off-by line.
>

So did you come to the conclusion that HID can't set up true (or real)
range for some of Saitek's axes upon input device registration?

-- 
Dmitry
