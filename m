Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbXFGOwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbXFGOwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXFGOwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:52:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:28167 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbXFGOwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:52:14 -0400
Date: Thu, 7 Jun 2007 16:22:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Jesper Juhl <jesper.juhl@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
In-Reply-To: <4667F00A.106@shadowen.org>
Message-ID: <Pine.LNX.4.64.0706071622070.8762@fbirervta.pbzchgretzou.qr>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
 <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>
 <4667F00A.106@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7 2007 12:46, Andy Whitcroft wrote:
>
>Jesper Juhl wrote:
>> On 04/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
>>>
>>> This version brings a host of changes to cure false positives and
>>> bugs detected on patches submitted to lkml and -mm.  It also brings
>>> a number of new tests in response to reviews, of particular note:
>>>
>> A  chmod +x scripts/checkpatch.pl  would be nice :)
>
>While git carries the permissions I am am pretty sure a straight patch
>doesn't.  Where did you pick up your copy from linus' tree or from the
>-mm one?

Linus's tree lacks the +x bit...


	Jan
-- 
