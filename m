Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbXHIUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbXHIUIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXHIUI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:08:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37190 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbXHIUI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:08:27 -0400
Date: Thu, 9 Aug 2007 22:08:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
In-Reply-To: <9a8748490708091303mc17bcfev1ed5b27851123aa6@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708092207530.13912@fbirervta.pbzchgretzou.qr>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
 <9a8748490708091303mc17bcfev1ed5b27851123aa6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9 2007 22:03, Jesper Juhl wrote:
>On 09/08/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>> Since the network device documentation needs a rewrite, I was thinking
>> of using basic html format instead of just plain text. But since this would
>> be starting an new precedent for kernel documentation, some it seemed
>> like a worthwhile topic for discussion.
>>
>> Advantages of html:
>>   * basic formatting like lists, italics, etc
>
> - List item 1
> - List item 2
> - List item 3
>
>/italic text/
>*bold text*
>_underlined text_

This is likely to generate false positives.


	Jan
-- 
