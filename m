Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXKHQUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXKHQUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbXKHQUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:20:31 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:60144 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXKHQUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VKspb0R8aHuVX6J9onCGIM82X5uaS1SqFUgnXcmN/2JQ+H7h97zzEXziNsf3xsU4kDbCtUpXMpwQHeBoUbcxeg4MX/XREuwZspqujnP0o/mdgbzMqFc+FY2OyKhDGMk2QEZMl72sD3BLCoo/phhgmnsm2CeWM/banIvoq951IGM=
Message-ID: <5d6222a80711080820j5e095e12k7fd1f1710cd1bd24@mail.gmail.com>
Date: Thu, 8 Nov 2007 14:20:25 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC 2/7] x86: clean up mm/init_32.c
Cc: LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Zach Amsden" <zach@vmware.com>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <20071108015310.059598778@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071108015008.660012621@goop.org>
	 <20071108015310.059598778@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -                       /* Map with big pages if possible, otherwise create normal page tables. */
> +                       /* Map with big pages if possible, otherwise
> +                          create normal page tables. */
/*
 * multi comment lines are preferred
 * this way, IIRC ;-)
 */



-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
