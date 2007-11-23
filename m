Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXKWQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXKWQo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXKWQoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 11:44:22 -0500
Received: from web51609.mail.re2.yahoo.com ([206.190.38.214]:36283 "HELO
	web51609.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751965AbXKWQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:44:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=wDRqfg4b8Sj3h+st3vXWVuaEGJW3nI1JDCSxRXn9DazdXjwIAKm6X7N6kMZ2VS1lwalihiFIg4YmX+OnmbeK2yLqRM8K+898DsMFVj6E7fzGGgLK3ziFS1kJ1/+TLA3aDVTtRjiSp0+sQj/tLI7fjFATbCm4vjtagsv9XzvBXn0=;
X-YMail-OSG: dCSk5wkVM1lygsiwUG3egoM8pQgBZNHWmcfNB.cH9LSt3InqcPH98oJyFjdOJhrc5BZvv.KcOcm0RHsSBHJvk8_OuJq2Yqp7RIJd3Y6_hMnzCZuznTd8zBX1hCzw6jznoJnnr0Frd7Y7sxBxa1qXkm1lFw--
Date: Fri, 23 Nov 2007 08:44:20 -0800 (PST)
From: Durand <titetan@yahoo.com>
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
To: linux-kernel@vger.kernel.org
In-Reply-To: <20071123122311.GA6685@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <557045.80338.qm@web51609.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I downloaded the updated cfs-v24 patch and applied to 2.6.22.13. Compiled and
ran fine. Suspend and hibernate are working on my nc6000 laptop now. Now I'm
off to compile and run 2.6.22.14. 

--
Thanks,

Durand
--- Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Durand <titetan@yahoo.com> wrote:
> 
> > Ingo,
> > 
> > Just applied this patch to 2.6.22.13 and 2.6.22.14. Compiles and runs 
> > fine but on my laptop, it prevents suspending and hibernating with 
> > "one tasks refuses to freeze" load_balance_mo.
> 
> please re-download the v24 patch, it should have this bug fixed.
> 
> 	Ingo
> 



      ____________________________________________________________________________________
Be a better pen pal. 
Text or chat with friends inside Yahoo! Mail. See how.  http://overview.mail.yahoo.com/
