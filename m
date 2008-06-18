Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYFRKNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYFRKNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYFRKNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:13:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:17802 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYFRKNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s6t5CBgMe9YeIYD2Mce54gt9A+YzyGieUl6wz6Hex3PR4rj9gp/oTR4N+cAnhasP1U
         1T+ZozAlIMZNnuTofHsUcYOms6DkJka25CdRUBJMHQr5p43QuHD37zqMP260WU9Qk/EQ
         MWCjASupLglss/ou1rMR+tT8VPKuiFD3v2spc=
Message-ID: <f1d7325b0806180313j7ced6726t1a0546833a15fa1c@mail.gmail.com>
Date: Wed, 18 Jun 2008 10:13:17 +0000
From: "vibi sreenivasan" <vibisreenivasan.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: WARNING : section mismatch while compiling 2.6.25.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080612181443.GC2271@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f1d7325b0806120029y5f5e0bd8i6caa626bf9af59df@mail.gmail.com>
	 <3219c8500806120033q60f02574p682e9331311eb0dd@mail.gmail.com>
	 <f1d7325b0806120707r4212c2e7x6b0f53218bc23bf9@mail.gmail.com>
	 <20080612181443.GC2271@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
   i have tried compiling latest kernel, here also i ma getting
section mismatch error.
   can you please say from where i can find out details regarding how
to fix this warning.
 thanks in advance
regards
vibi sreenivasan


On Thu, Jun 12, 2008 at 6:14 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Jun 12, 2008 at 02:07:40PM +0000, vibi sreenivasan wrote:
>> hi,
>> i tried with make defconfig & then make .
>> i am getting same error.
> This is a warning that should be fixed in latest -rc kernel
> by commit: ed49f5d0015927334dcca3607a9bfc1478ff8f55
>
> You can safely ignore the warning.
>
>        Sam
>
