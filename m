Return-Path: <linux-kernel-owner+w=401wt.eu-S937694AbZAPVva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937694AbZAPVva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761894AbZAPVvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:51:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:62763 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763953AbZAPVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:51:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o5JEqGyRDHYvwPndlOXIlyvmZmLwspzSomhm5EOAc8oO9XoCNneEDoRfIKbG3jLjX6
         kg1+fKPa7zTOBTTnl1giqMCCnUK6c0aDvENS1A+IpEKl2rmItoCY7y61hRIQGbbZLYiH
         RwN2BgNRc/boTATLSxDrTEdd6jhpklMiAIjZo=
MIME-Version: 1.0
In-Reply-To: <1232141721.16367.125.camel@macbook.infradead.org>
References: <20090116080503.GA11855@auto.tuwien.ac.at>
	 <1232129665.25018.8490.camel@macbook.infradead.org>
	 <20090116212703.GA11952@auto.tuwien.ac.at>
	 <1232141721.16367.125.camel@macbook.infradead.org>
Date: Sat, 17 Jan 2009 00:51:16 +0300
Message-ID: <b6fcc0a0901161351x532baffbx818fe925a07cafda@mail.gmail.com>
Subject: Re: Compile error in drivers/video/backlight/mbp_nvidia_bl.c - 
	v2.6.28
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Martin Koegler <mkoegler@auto.tuwien.ac.at>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 12:35 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2009-01-16 at 22:27 +0100, Martin Koegler wrote:
>>
>> The bug is still present in:
>> commit 7cb36b6ccdca03bd87e8faca7fd920643dd1aec7
>
> OK, I'll chase it up when I have decent connectivity again... hopefully
> in a few hours.

Knock, knock!

http://marc.info/?l=linux-kernel&m=122723239529328&q=raw
