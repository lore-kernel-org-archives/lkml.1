Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYFKGQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYFKGQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYFKGPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:15:39 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:26118 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752344AbYFKGPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:15:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CrviXXyn5KT1ayUAGq+pKhca8GPKLal1hhh3OYWqQ8ab6mr0fTJVVw9ieBgXCcsz7hmwtT25dQ1bmLxYVdRcEioAUqa6FfX8ILWCfAgLZVV1McWo/tUCSl6EhBMGRkbQP1MOBbkG8ycOiZV949FvAVaMQER14jy+fSpYGMfr6fI=  ;
X-YMail-OSG: jniK7NgVM1nuAh6qr1XtpwBvRNykI.dkD1hl0z7iR_jUSbUYyoELk1yTA2qDSrZmwMK_WO5it1yc8p9KBdioysiC2sCivPrEYiaMgiKpNKbAwCwWEunsTr5N2Hq3M9rLkLY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.26-rc5-mm2: OOM with 1G free swap
Date: Wed, 11 Jun 2008 16:15:25 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <20080611060029.GA5011@martell.zuzino.mipt.ru>
In-Reply-To: <20080611060029.GA5011@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111615.25508.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 16:00, Alexey Dobriyan wrote:
> On Mon, Jun 09, 2008 at 10:31:45PM -0700, Andrew Morton wrote:
> > - This is a bugfixed version of 2.6.26-rc5-mm1 - mainly to repair a
> >   vmscan.c bug which would have prevented testing of the other vmscan.c
> >   bugs^Wchanges.
>
> OOM condition happened with 1G free swap.

Hey, I'm liking this kernel-testers list, btw. Makes it much easier
to help people with problems.

Luckily I suggested it at last KS. Oh wait, I recall everybody
laughed or ignored :) I guess I lack the managerial qualities to
make those kinds of suggestions!
