Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0BIJ2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 04:28:06 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:60446 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BIJ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 04:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=RG5ZLjEaB4UVLVD8dYwsvtECW42m/gtpyXaydFJB/E9mD4gzjd1VMJE4mXaHPw2DNZ
         7qWQy+7+Ru4PP1WC7qibiMdaJCUkHWR1Am27GZv/7Jc1sK3nYKXThO4nu6IJoUS09TZu
         7wWzOQC39LIm6uhcTgVjCT9TxAYJiyMAVcHss=
MIME-Version: 1.0
In-Reply-To: <430c80e91002090103l5751d569pd306ca1f0ccca8ba@mail.gmail.com>
References: <430c80e91002090103l5751d569pd306ca1f0ccca8ba@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 9 Feb 2010 14:57:43 +0530
Message-ID: <430c80e91002090127u1742d043ub29f1c547fe73590@mail.gmail.com>
Subject: Fwd: Possible performance improvement?
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, Feb 9, 2010 at 2:33 PM
Subject: Possible performance improvement?
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>


Hey Ingo,

I recently happened to come across this thesis[1] which
presents some very concrete results with stats regarding
the performance of Linux CFS with an implementation of Redline.

It would really be great if you could take some time out of your
busy schedule and quickly look up the figures to see the performance
comparison and if we could adapt some ideas. I am willing to give it
a try if you think its worth it.

Thanks,
--
Pranith.


[1] http://scholarworks.umass.edu/cgi/viewcontent.cgi?article=1071&context=open_access_dissertations
