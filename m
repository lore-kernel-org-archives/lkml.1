Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbZIPMzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbZIPMzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758915AbZIPMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:55:32 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:63091 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbZIPMzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rzJN9mEFRI0wBhw1aaEwCCc3LxrCvsYYv3Q/ZSjy8EQwKON/n5mSVGlWv5ab/1pHJd
         cB96d6YIVk+lj+QuGGPlesHrI9t9E+SmFTrg7KXmkmS97qhkyQW5B4CswJjy1dMyfmBq
         lekdT2bNkekS4041V/N84gz6Asx81PVQ8gQiU=
MIME-Version: 1.0
In-Reply-To: <20090916050236.GF2756@core.coreip.homeip.net>
References: <20090915062050.GB10232@core.coreip.homeip.net> 
	<1253062178-18196-1-git-send-email-vapier@gentoo.org> <20090916050236.GF2756@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 08:55:13 -0400
Message-ID: <8bd0f97a0909160555n390ad48dhf19c7eac5c3783fe@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] input/keyboard: add ADP5588 
	QWERTY I2C Keyboard Input device driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 01:02, Dmitry Torokhov wrote:
> On Tue, Sep 15, 2009 at 08:49:38PM -0400, Mike Frysinger wrote:
>> From: Michael Hennerich <michael.hennerich@analog.com>
>>
>> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> ---
>> v2
>>       - merge my and Dmitry's clean up fixes
>>
>
> Looks good, I'd also like to add this instead of recalcularing delay
> every time:

makes sense to me.  you going to merge that, or should i merge & repost as v3 ?
-mike
