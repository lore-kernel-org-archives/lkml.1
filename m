Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYGEKRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYGEKRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYGEKRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:17:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:62414 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYGEKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T7rp96r/Pe/b7d7fTdrnDmkb1VGE3nQ3W1zAAsD9nRAbmWpaJRYjLjBjwGDboUmWm5
         ZT6vnwn08sh1QxsvqyeD/lnuH8Pt/BVl9YwM6KTmExGUigN6yr6H3Ojnfxgc3VuWaEtv
         gyumLWaJqXHCU5utVnh+h8tk+QgPAb8HdNA4w=
Message-ID: <36ca99e90807050317m7160c3eaj150ceac4440752a1@mail.gmail.com>
Date: Sat, 5 Jul 2008 12:17:29 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [9/9] MCE: Use 64bit machine check code on 32bit
Cc: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <486F44C0.8050003@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807041120.678642023@firstfloor.org>
	 <20080704212033.D40551B431F@basil.firstfloor.org>
	 <36ca99e90807050250u718fa277t2297d6436fd14c4e@mail.gmail.com>
	 <486F44C0.8050003@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 11:54, Andi Kleen <andi@firstfloor.org> wrote:
>
>> Is this first "n" a typo?
>
> No. The legacy machine check code that is going away is definitely
> supposed to be default n. This is effectively a default y for
> the new code.
I didn't mean the "default n", but the "If you're still sure you want it, say n"

Bert
>
>
> -Andi
>
