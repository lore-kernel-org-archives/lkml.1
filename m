Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZBTVfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZBTVfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZBTVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:35:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:59959 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZBTVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fNqECjVA7LHCv6QOds7Ch2u5Z64jcwaXPyd2dEuyzvFUEFBJGflpcH6dCwbx30kpTE
         zvzwaohggx/GeX2CZRgRhoj0eQi001FmSu6NjZNzuDqzvN8z+Zb85yLiuQgdEN+7u9Lz
         6RcDnI51U11bFKA94dA+Nq7EinMYgHQKyN04M=
MIME-Version: 1.0
In-Reply-To: <499DA235.6090700@oracle.com>
References: <20090220002832.cad00fcd.sfr@canb.auug.org.au>
	 <499D93F0.2090803@oracle.com>
	 <71cd59b00902191012k764bab32n85f54fc049e35035@mail.gmail.com>
	 <499DA235.6090700@oracle.com>
Date: Fri, 20 Feb 2009 22:35:40 +0100
Message-ID: <71cd59b00902201335y3cc0acacod7257548a76ed6b9@mail.gmail.com>
Subject: Re: [PATCH -next] eeepc: needs to depend on INPUT
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 7:17 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Corentin Chary wrote:
>> On Thu, Feb 19, 2009 at 6:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> EEEPC_LAPTOP needs to depend on INPUT to fix build errors that
>>> can happen when EEEPC_LAPTOP=y and INPUT=m:
>>
>> There is already a patch sent to linux-acpi and Len Brown.
>>
>> http://patchwork.kernel.org/patch/7354/
>
> Today's linux-next doesn't build (doesn't have that patch).  :(
>

Hi Len,
Just a reminder for the patchs I send some days ago to fix this build
error, and two regressions. In case you miss them.

http://patchwork.kernel.org/patch/7354/
http://patchwork.kernel.org/patch/7357/
http://patchwork.kernel.org/patch/7356/

Thanks

-- 
Corentin Chary
http://xf.iksaif.net
