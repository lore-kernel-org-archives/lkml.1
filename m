Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZA0Ga4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZA0Ga4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 01:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZA0Gao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 01:30:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:41988 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZA0Gao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 01:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iYOTgMWuEBUidKnCwXOJPt8wzSMI0EFF2XPXt/0QD5QIAwHC3jOiwAM9fsYHJ1Yzer
         Df6ZI444JHG2hzGiEX7Jw5gBm109z6KjgAMEbAq+vH0Jm067bfO+OsfvviTFGFD+5T08
         2dkN2XXGvD/ORmVrxmqa2JQFkXkKyZSZNp524=
MIME-Version: 1.0
In-Reply-To: <497870A3.4070200@turknet.net.tr>
References: <49771D65.3090205@turknet.net.tr>
	 <20090121152818.GA3438@x200.localdomain>
	 <497870A3.4070200@turknet.net.tr>
Date: Tue, 27 Jan 2009 12:00:43 +0530
Message-ID: <3f9a31f40901262230s3efb9242jcd4a02ee84944daa@mail.gmail.com>
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 6:42 PM, Tarkan Erimer
<tarkan.erimer@turknet.net.tr> wrote:
> Alexey Dobriyan wrote:
>>
>> # CONFIG_FIRMWARE_IN_KERNEL is not set
>>
>> Try setting this option to =y.
>>
>
> Thanks for the reply. I tried with "CONFIG_FIRMWARE_IN_KERNEL=y" as you
> suggested. But, still I get the same warning.
> It looks like ubuntu's make-kpkg utility or kernel compile process do not
> care about "CONFIG_FIRMWARE_IN_KERNEL=y" and still building modules without
> firmware built-in.
>
>

Is this ubuntu's specific problem or you also getting these
warnings/errors on another releases.

--
JSR
