Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZLKI7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZLKI7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZLKI7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:59:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59856 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZLKI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iIRlvUnrFee1XKpCKo5hPGDnoZMqtQ9AVJpFjzwy8vXa18Hpi8q0LAQZHEe6b8qG8n
         I23Y4XLb/4GPrBK6TUYJNpUuSpICs6w0j/u/HkqldYniUUmC8JQDuxSB6VyRvKcNueBO
         NcEoiL1EEc1n3qqsZJ1kUskWZ16WMVzHtgqLU=
MIME-Version: 1.0
In-Reply-To: <1260519040.12157.233.camel@debian>
References: <a8e1da0912100127k4dcddd65gfe5ff0b1330fe63b@mail.gmail.com>
	 <a8e1da0912100130i2e654796mf899dd27df869673@mail.gmail.com>
	 <20091210184931.257A.A69D9226@jp.fujitsu.com>
	 <4B217219.6040109@crca.org.au>
	 <a8e1da0912101747l7e0e9fcbh8a7007e95e7c8509@mail.gmail.com>
	 <1260499048.12157.219.camel@debian>
	 <a8e1da0912101935g99a0902m43136a05edea938b@mail.gmail.com>
	 <1260519040.12157.233.camel@debian>
Date: Fri, 11 Dec 2009 16:59:10 +0800
Message-ID: <a8e1da0912110059q19613f0ak25383436253e25a7@mail.gmail.com>
Subject: Re: mmotm-2009-12-08-17-45 resume slowly
From: Dave Young <hidave.darkstar@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 4:10 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Fri, 2009-12-11 at 11:35 +0800, Dave Young wrote:
>> > Try powering off the AP before resume?
>>
>> Unfortunately, I use public wireless resouce, so I cann't do that.
>
> Then move the laptop away.

Tried, still can not produce.

>
> Thanks,
> -yi
>
>



-- 
Regards
dave
