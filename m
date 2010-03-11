Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0CKS3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:29:54 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:60719 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab0CKS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X6QrJ2UOJGns4+2XTuHDXXaiETW4J7FKud/5HTPzkWVjzIiI8fjdxllXhJUPlmA263
         yqDTymMU4Q28n8vyiBPfTAg7hdcyG76ZKOpv3uhJm/E2qm7uphBdtxjp7PO2xhYL503c
         /8RSHXxKvDW+aFfUE6aA6aVoJEgjl58/Efzvw=
MIME-Version: 1.0
In-Reply-To: <4B8FC6AC.4060801@teksavvy.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
	 <87f94c371003040617t4a4fcd0dt1c9fc0f50e6002c4@mail.gmail.com>
	 <4B8FC6AC.4060801@teksavvy.com>
Date: Thu, 11 Mar 2010 13:29:43 -0500
Message-ID: <87f94c371003111029s7c7daebgf691ab11e6bdda25@mail.gmail.com>
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, foo saa <foosaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> But really.. isn't "hdparm --security-erase NULL /dev/sdX" good enough ???
>

This thread seems to have died off.  If there is a real problem, I
hope it picks back up.

Mark, as to your question the few times I've tried that the bios on
the test machine blocked the command.  So it may have some specific
utility, but it's a not a generic solution in my mind.

Greg
