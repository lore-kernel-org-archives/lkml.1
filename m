Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZIPESR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZIPESR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbZIPESP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:18:15 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:53312 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZIPESM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=I6bimC0toIJF6mwMWwO5LCVHJDrOKecM2lXc4cCBeb6gVfK0cUC8PcgN69c9bRK5SD
         QXytj+iXmXddG3WKU9EL/KWFX8wl7QTWf/oeDGhdXv7A1R/glWw+V78QMHinr5/gIjhk
         jez8MR1uVCYLjIKDdPEhJ/LDvN8u3MJ6nsJjg=
MIME-Version: 1.0
In-Reply-To: <20090915211558.85a7825a.akpm@linux-foundation.org>
References: <20090915161535.db0a6904.akpm@linux-foundation.org> 
	<20090916000357.GD23923@linux-sh.org> <20090915171826.4bd7f1d4.akpm@linux-foundation.org> 
	<8bd0f97a0909152051s4a25b9eej581c68a3b10fda3@mail.gmail.com> 
	<20090915211558.85a7825a.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 00:17:56 -0400
Message-ID: <8bd0f97a0909152117p2c88d8cey46a109898955777a@mail.gmail.com>
Subject: Re: 2.6.32 -mm merge plans
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, dedekind1@gmail.com,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, kmpark@infradead.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 00:15, Andrew Morton wrote:
> On Tue, 15 Sep 2009 23:51:25 -0400 Mike Frysinger wrote:
>> http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=shortlog;h=for-mtd
>>
>> hopefully they make it in this cycle (they were posted a while ago to
>> the mtd lists w/feedback addressed)
>
> Wanna mail them out in the usual fashion?

if i dont see them in the next mtd merge in the 2.6.32 window, i'll
bounce them over to you
-mike
