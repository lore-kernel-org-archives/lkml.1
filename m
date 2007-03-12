Return-Path: <linux-kernel-owner+w=401wt.eu-S965520AbXCLKrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520AbXCLKrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXCLKrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:47:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:38724 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965520AbXCLKrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=oGQAzYrU7upUkIkhA8BEYX7MlyOh+DstSPufkGWQUFgMI+SwuCsz3wMUdexrCTo7/tSLtMHlR4DYQ5ekQ1G2Ge9rtXfuGWDpO8xaYWidNIhoj/+l0FcAiIVb1KVnbQ1yLYbRhEp/HMzLgdvbc5yCk2m1ep/9LFCtIiI0srTEcpU=
Date: Mon, 12 Mar 2007 12:45:48 +0200
To: Amit Choudhary <amit2030@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/media/video/videocodec.c: check kmalloc() return value.
Message-ID: <20070312104548.GA26264@Ahmed>
References: <20070308231401.42679647.amit2030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308231401.42679647.amit2030@gmail.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Thu, Mar 08, 2007 at 11:14:01PM -0800, Amit Choudhary wrote:
> Description: Check the return value of kmalloc() in function 
> videocodec_build_table(), in file drivers/media/video/videocodec.c.

No need for `Description:'. This line is automatically put in the logs 
as a patch description if the patch got accepted. 

It's better not to use very large lines. 

Also there's no need to specify the exact function in the log, it's already
displayed in the patch.

> 
> Signed-off-by: Amit Choudhary <amit2030@gmail.com>
> 

As said in Documentation/SubmittingPatches put a "---" line after
Signed-off-by signature.

Thanks,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

