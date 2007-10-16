Return-Path: <linux-kernel-owner+w=401wt.eu-S935576AbXJPUug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576AbXJPUug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936060AbXJPUtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:49:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:41785 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936047AbXJPUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nZNo96W2s/9cnqcKnr0EOu7bHb9zNY27kncEHOXvkMya4fCsIHVH/CAxkoqm/Kl+7XJ/K9NzTDMI7vQ6k8x/i+mz5Sjy7EHI9oHBTyJmvxwm1IsyVVNIL6KB2RgryKpfxs9iJUQHCk4bHZJJcuisR7UmNVmVvEdFLvc30vaFqiY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [PATCH] : IDE-CS Add additional id string (corsair, 1GB)
Date: Tue, 16 Oct 2007 21:35:51 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071014210403.13d6f560.Kristoffer.Ericson@Gmail.com>
In-Reply-To: <20071014210403.13d6f560.Kristoffer.Ericson@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710162135.51149.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007, Kristoffer Ericson wrote:
> Greetings,
> 
> The manf string looks weird (0x0 + 0x0), but I assume its correct. Also,
> whitespaces seems almost intentional, so am I missing something? 

Nope, thanks for cleaning this.

> Shortlog:
> This patch adds id strings for Corsair 1GB (identified as Hyperstone Model1)
> inside legacy/ide-cs.c 
> 
> It also includes some minor whitespace cleanups.
> 
> Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

applied
