Return-Path: <linux-kernel-owner+w=401wt.eu-S1764289AbYESWmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764289AbYESWmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYESWmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:42:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:14327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYESWmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:42:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=olK7ZhagmFBkRaQ8nd40+SE3mPdh3VzQtS4kOJNch+Razg8smGdPH80QX9KXIZUW/zhWEEH4q+VU6eZCCXbQpuiKQcblGxxc2IQEajLFR2UZpHyqiSSnM5vkIKNMTtJa3OsMonYfEf6W4SzYyYkowXq4wyEBwOoRtF6cxABcEqw=
Message-ID: <9e4733910805191542m671a2200je2d9251721cbdf90@mail.gmail.com>
Date: Mon, 19 May 2008 18:42:21 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] cpufreq: remove CVS keywords
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080519220315.GG17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080519220315.GG17716@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/08, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes CVS keywords that weren't updated for a long time
>  from comments.
>
>  Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks for doing this. I'd love to see all CVS keywords removed from
the kernel source. I've spent countless hour cleaning up kernel
patches after various embedded vendors checked their kernel source
into CVS and then generated patch sets containing their changes plus
all of the expanded keywords.

-- 
Jon Smirl
jonsmirl@gmail.com
