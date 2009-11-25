Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZKYGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZKYGHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZKYGHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:07:05 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48577 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZKYGHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:07:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P8qVdXRLtitek5xJQO8DAuYfFo/kAxuUTcJoyb6KZJmfFdqfwjoMFef3V6+OYSJaZp
         yU4XGtUe5uqH54Oy6rwtLM/QalldDW9ZXZfTye8flNURcN5m8saai4aLS/WzQR1vm05A
         KE/AsmWTh40fIEkjHf1IWoJBRLPcQMmnIqidE=
MIME-Version: 1.0
In-Reply-To: <da1989290911241958o88d49a8i14a2c9b39f1f101b@mail.gmail.com>
References: <1259148311-31724-1-git-send-email-cliffcai.sh@gmail.com> 
	<8bd0f97a0911241951o5394972dl65c48371f4149b7d@mail.gmail.com> 
	<da1989290911241958o88d49a8i14a2c9b39f1f101b@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 25 Nov 2009 01:06:49 -0500
Message-ID: <8bd0f97a0911242206u535b829u1c9fbc8a2c0f12a0@mail.gmail.com>
Subject: Re: [PATCH v2] [mmc/host]:Blackfin SD Host Controller Driver
To: Cliff Cai <cliffcai.sh@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       cliff.cai@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 22:58, Cliff Cai wrote:
> On Wed, Nov 25, 2009 at 11:51 AM, Mike Frysinger wrote:
>> On Wed, Nov 25, 2009 at 06:25,  <cliffcai.sh@gmail.com> wrote:
>>> From: Cliff Cai <cliffcai.sh@gmail.com>
>>>
>>> v2-v1 change:remove mmc host before releasing it in sdh_probe().
>>>
>>> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
>>> ---
>>
>> changelog info should be below the ---, not above.
>
> is this true?

things above the --- are the changelog and go into the git commit.
things below are transient notes for people looking at the patches.
-mike
