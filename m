Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZJYXhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZJYXhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 19:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbZJYXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 19:37:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43869 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZJYXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 19:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TMpYoBm1O+F+iN41K5auSRtViqYDaC71tgaug/dkCBYthxjnIyqsp7Rf0aKNUyDRnF
         lo/UDirfNOPvvVFLS5ETU2jml3DmQbIcEp459F6nUuummOUiiPyU6APGiSfcRjlApGyq
         dWh1S2FZNt+pyCuPohCmD3ma8gPR7nYH+zTaw=
Message-ID: <4AE4E12D.5070304@gmail.com>
Date: Mon, 26 Oct 2009 00:37:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: writable limits to -next [was: Adding to linux-next?]
References: <4AC6339B.7000905@gmail.com>	<20091006225751.7d5f3eec.sfr@canb.auug.org.au>	<4AE16B0A.7020400@gmail.com>	<20091026094741.5a1d492c.sfr@canb.auug.org.au> <20091026095543.1bb1a25f.sfr@canb.auug.org.au>
In-Reply-To: <20091026095543.1bb1a25f.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2009 11:55 PM, Stephen Rothwell wrote:
> On Mon, 26 Oct 2009 09:47:41 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> On Fri, 23 Oct 2009 10:36:26 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>> Hi, could you please add git://decibel.fi.muni.cz/~xslaby/linux#limits
>>> into the -next tree?
>>
>> I have added it from today.
> 
> It is actually git://decibel.fi.muni.cz/~xslaby/linux#writable_limits, right?

Hi. Oops, of course it is.

/me wondering: am I that dumb?
