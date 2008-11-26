Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbYKZIFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbYKZIFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKZIFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:05:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:2162 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYKZIFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=b6W7IwUiyHAsf1PAeSoeyh/LRSvp2bksrjTjpQmiQ9V10m6jTNyQ4qWAvPyA8r5bjI
         PLWnF4PiT9/se4rNWkmrxqAGdRNOFPf975xUXJ4iXeINQmDCNA4uL5r9wnHXIdRwYDLa
         qsMdo1CK0GxCRn+rxXcqxCC0VzX1+ZfFlNjeg=
Message-ID: <84144f020811260005s2e54e05fy45e14c6ab3b7c3f@mail.gmail.com>
Date: Wed, 26 Nov 2008 10:05:06 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pascal Terjan" <pterjan@mandriva.com>
Subject: Re: [PATCH] Fix comment on #endif
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <1227622099.15127.8.camel@plop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227622099.15127.8.camel@plop>
X-Google-Sender-Auth: 82e87b5bd6047b3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 4:08 PM, Pascal Terjan <pterjan@mandriva.com> wrote:
> This #endif in slab.h is described as closing the inner block while it's for
> the big CONFIG_NUMA one. That makes reading the code a bit harder.
>
> This trivial patch fixes the comment.
>
> Signed-off-by: Pascal Terjan <pterjan@mandriva.com>

Applied, thanks!
