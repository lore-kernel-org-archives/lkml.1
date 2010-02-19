Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0BSLl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:41:57 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57320 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0BSLl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:41:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X6cXJwmO3oDWUtM3ksMQjZZGegGu/OLhsK7HeJZ9YRF5xUC7M9m0X8nJDq+7Jcm0Vs
         MAD3qK0IxchJvGgInnnDZpIGhDw/VSToYywZCS5TQ8pbYj35HSX2QN1wyGOsnvOISQYL
         VMehUuCSjOFY/QaUsXV+yeh43Wp3s0oaw9rtM=
MIME-Version: 1.0
In-Reply-To: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
Date: Fri, 19 Feb 2010 13:41:54 +0200
Message-ID: <5ec8ebd51002190341k389064aao4a472e048ed26588@mail.gmail.com>
Subject: Re: [PATCH 00/12] Clean up code to use native kernel functions when 
	convert or check hex digits
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 8:55 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:

I have got a commentary from Uros Bizjak about previous work [1].

Additionally I'd like to sort out patches for two series - one is
about clean up code and substitute custom functions by existing ones,
the other is about introducing hex_to_bin() helper.

So, I'm going to prepare mentioned series. Please decline that one,
but patch #1 which already has been Acked. I will include Cc field as
well.
Meanwhile I found more places with the same functionality.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0805.0/0324.html

P.S. Actually the idea to fix this mess was come to me by Alexander Shishkin.

-- 
With Best Regards,
Andy Shevchenko
