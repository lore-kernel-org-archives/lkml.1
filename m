Return-Path: <linux-kernel-owner+w=401wt.eu-S939779AbXGSPzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939779AbXGSPzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936011AbXGSPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:55:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:63025 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934513AbXGSPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bm3Ep2OJKr+FkH7MY4qWp+Agf1NKSdKXiGgjkKUXLN3XSxBMDeH/gCiJWek61CQ9XKNcEFw23+q/rdOHG63sT4a3fmQTbYTfKtvuidPeu7cPVieQs9/DrNwZtOEV879NGkh1Bx1tFDyZTw6xPKl1iNW4xFl7joHbAAG069WIzJk=
Message-ID: <91b13c310707190855h6fee9604pcc86b6712d2c76f8@mail.gmail.com>
Date: Thu, 19 Jul 2007 23:55:18 +0800
From: "rae l" <crquan@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] nbd: use list_for_each_entry_safe to make it more consolidated and readable
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Steven Whitehouse" <steve@chygwyn.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <469F7F58.4080709@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11848376711601-git-send-email-crquan@gmail.com>
	 <469F7F58.4080709@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Paul Clements <paul.clements@steeleye.com> wrote:
> Could you name "n" as "tmp" (as in the previous code) so that it's clear
> that's only a temporary variable. Other than that, this looks good.
Sure. I just use the name "n" as in the declaration of
list_for_each_entry_safe in the header file <linux/list.h>
I'll resend it a little later.

>
> Thanks,
> Paul
>

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
