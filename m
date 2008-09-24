Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYIXRL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYIXRL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYIXRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:11:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:14473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXRLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=n9FUhUZl3UPAVNixgWPhsMQLBRpsmwT4aVyss7X06auH+spryow259SLBeG3SZ3BTs
         nLRsrfrPflWGSbi4ihPfvAxETpmqeA5Sbks/GGy5Yw0rGo4IXAXUXTEG+/pVU9MBqrfd
         FUrrvnQR2olstR9BlzOTeHP/ke1DNHtcNeo+g=
Message-ID: <86802c440809241011l7c8a27c5x19829e49cbc3f6f9@mail.gmail.com>
Date: Wed, 24 Sep 2008 10:11:16 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [patch 0/3] [x86 -tip/master] apic cleanup
Cc: mingo@elte.hu, macro@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <48da6f73.0405560a.6f2f.ffffa11c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48da6f73.0405560a.6f2f.ffffa11c@mx.google.com>
X-Google-Sender-Auth: 5fe7bb9338e7ec8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 9:46 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>  Hello there,
>
> this series does contain a few apic,ioapic cleanup patches.
> Please review. Any comments are _quite_ appreciated!
>
> They are quite trivial so should not take too much time
> to review :)

all three look good.

YH
