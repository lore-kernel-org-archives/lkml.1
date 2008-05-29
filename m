Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbYE2XMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbYE2XMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYE2XM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:12:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:9843 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYE2XM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nMH+Vf8y8GSgDoEZYAajTYyIHV20cdPTCQA43Hesr2Y0V4NomgOjutyl208OhLIMwXfZ/36grXoWwqi16Fw4YHuHBvWicYxxj02ng4LczEvXBqLdNste+KrlCzOWeMuN3ZXL0VqB4TP99j/q0aMjGn8PQJKpbQFEDGQftHQJicw=
Message-ID: <e9c3a7c20805291612s3a10358cy1ea0809185e5dc13@mail.gmail.com>
Date: Thu, 29 May 2008 16:12:22 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [PATCH] arm: fix header guards
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk@arm.linux.org.uk>
In-Reply-To: <20080527161153.GE7550@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080527161153.GE7550@damson.getinternet.no>
X-Google-Sender-Auth: 4babe6f1d799a231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Tue, May 27, 2008 at 9:11 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 27 May 2008 17:32:10 +0200
> Subject: [PATCH] arm: fix header guards
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
[..]

Acked-by: Dan Williams <dan.j.williams@intel.com>

I would go ahead and submit this to Russell's tracker:
http://www.arm.linux.org.uk/developer/patches/

...but it will probably trickle its way in via -mm.

Regards,
Dan
