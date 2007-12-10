Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbXLJU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbXLJU5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXLJU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:57:34 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:3540 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbXLJU5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N01Mn4AqyTXJ4N0t/aSx3nEmkWIvbYxfCJKbQBZFut7M8GDPTGq0dDbTKNqyknNVnEFc0R3JAuiH4q0lStGa1bGe9t6JWxzS5Cu+2t23gUGjw/h9+N1lbMFOpXFzS/OvZmk15bEJJdiMJP807aUcQkTlGohoHb60YqsJqX7sVTw=
Message-ID: <3d8471ca0712101257v792ffe37n49271f5a202b63e0@mail.gmail.com>
Date: Mon, 10 Dec 2007 21:57:28 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071210204212.GA5502@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712080340.49546.rjw@sisk.pl> <20071210204212.GA5502@elte.hu>
X-Google-Sender-Auth: 2e80a62db5a0e0f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 9:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
> although some claimed effect was on udelay()/mdelay() too.

Any specific report?
The jumping sched_clock on frequency change caused some
scheduling oddities for me, but CFS attenuated the effect.

Thanks.

-- 
Guillaume
