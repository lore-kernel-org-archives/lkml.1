Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358Ab0AMVDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0AMVDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041Ab0AMVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:03:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:44447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0AMVDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:03:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WeMWtLXpyPHMyBFhT/vtGdd7xaOhSRsR+naIska8BS+J6FizcLe9C6zG5FbD01RQNG
         pmbvhBBBSD4jbE7eIrtWHAJykzkqgP4pi5XE3KNcFF2KM9rJQm+qY07mAJxyJQa+45+X
         3TF6ox61X696px1pcgd44GHmeZwy+clv6vxAY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
Date: Wed, 13 Jan 2010 23:03:00 +0200
X-Google-Sender-Auth: f8df93efe320b77e
Message-ID: <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
Subject: Re: Linux 2.6.33-rc4
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 7:44 AM, Linus Torvalds <torvalds@linux-foundation.org>
wrote:
> Hmm. Odd release. Something like 40% of the patches are in DRM (mostly
> nouveau and radeon, both staging, so it's a bit less scary than it sounds.
> But there's a noticeable i915 component too). That's all pretty unusual,
> afaik.

2.6.33-rc4 still suffers from an annoying screen flicker with i915 and
KMS on my machine. I *think* it started with 2.6.33-rc1 but I haven't
had the time to dig deeper.

                         Pekka
