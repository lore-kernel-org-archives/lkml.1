Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0CERxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:53:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54933
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab0CERxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:53:47 -0500
Date: Fri, 05 Mar 2010 09:54:06 -0800 (PST)
Message-Id: <20100305.095406.115464327.davem@davemloft.net>
To: xavier.bestel@free.fr
Cc: daniel@fooishbar.org, skeggsb@gmail.com, airlied@linux.ie,
       crmafra2@gmail.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, penberg@cs.helsinki.fi,
       dri-devel@lists.sf.net, torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: Making Xorg easier to test
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267811424.3405.110.camel@skunk>
References: <20100305154143.GD2505@tempa>
	<20100305.074932.225568964.davem@davemloft.net>
	<1267811424.3405.110.camel@skunk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xavier Bestel <xavier.bestel@free.fr>
Date: Fri, 05 Mar 2010 18:50:24 +0100

> On Fri, 2010-03-05 at 07:49 -0800, David Miller wrote:
>> From: Daniel Stone <daniel@fooishbar.org>
>> Date: Fri, 5 Mar 2010 17:41:43 +0200
>> 
>> > I understand that you guys are upset about this, so maybe you'd like to
>> > donate, say, 10% of your developer base to help out? That'd be pretty
>> > ace.
>> 
>> You have to support less than %10 of the amount of hardware we have to
>> support.
> 
> You can't compare a network card and a GPU. The latter is way more
> complex to code for.

I wasn't talking specifically about network cards.  But if you want
specific examples...

How about the x86 or parisc cpu, and all their derivatives, are those
complex enough for you? :-)

I've worked on OpenGL capable grapics card drivers of various
vintages, and I honestly don't think there is anything in there more
complex than what we have to deal with in the kernel.
