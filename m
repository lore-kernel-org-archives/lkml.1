Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZDVHun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZDVHun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZDVHud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:50:33 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:56947 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752127AbZDVHuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:50:32 -0400
Message-ID: <49EECC96.7050407@pardus.org.tr>
Date: Wed, 22 Apr 2009 10:51:50 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.21 (X11/20071115)
MIME-Version: 1.0
To: petkovbb@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.30_rc1] powernow-k8: oops during initialization
References: <49E7175D.6060808@pardus.org.tr> <20090422073833.GA23936@liondog.tnic>
In-Reply-To: <20090422073833.GA23936@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote On 22-04-2009 10:38:
> BIOS is missing the _PSS objects on which powernow-k8 relies. I'm pretty
> sure you had similar message in earlier kernels but it was a simple
> warning then.
>
> Is it possible to upgrade your BIOS? If you're lucky, it might've been
> fixed :).
>   
> Just read what the message says: it is not a kernel bug but simply your

Yes I'm aware about the firmware bug but the backtrace shouldn't appear
on the kernel log buffer, and yes I was having the firmware message with
2.6.29 too but not with that backtrace.
