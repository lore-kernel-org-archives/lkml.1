Return-Path: <linux-kernel-owner+w=401wt.eu-S1422899AbXBASTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422899AbXBASTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422914AbXBASTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:19:13 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:35995 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422899AbXBASTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NxZwV5fA/hOundN27tL+DIZz2UORFMDQQWJ5O2eIuwiow3bCC7BcEjQG7/WAOXuHekdh71xuycAhap+88kQ/MVa7SOv/wua9B1WQEg0CLMfgHWHywyvJO6zpJquXQAu0WQ+SDv0aS65q4eu0PEwV7myZeb7zpBFP6GS2yeeK3nc=
Message-ID: <f383264b0702011019ha411ef7t3447e65f6266917e@mail.gmail.com>
Date: Thu, 1 Feb 2007 10:19:08 -0800
From: "Matt Reimer" <mattjreimer@gmail.com>
To: "Rodolfo Giometti" <giometti@enneenne.com>
Subject: Re: Advice on battery support [was: Advice on APM-EMU reunion]
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-mips@linux-mips.org
In-Reply-To: <20070201095904.GE8882@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070129230755.GA8705@enneenne.com>
	 <20070130010055.GA15907@linux-sh.org>
	 <20070201095904.GE8882@enneenne.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Rodolfo Giometti <giometti@enneenne.com> wrote:
>
> Ok, starting from these patches I'd like to add a "battery support" to
> the kernel.
>
> What I suppose to do is a new class with a proper methods useful to
> collect several info on battery status, such as get_ac_line_status()
> get_battery_status(), get_battery_flags(),
> get_remaining_battery_life() and so on.

Wasn't there recently a big discussion on lkml about a battery class?

Matt
