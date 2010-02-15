Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0BOWPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:15:40 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:40015 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0BOWPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YoLt/LF4FBgJn0PPXhMobqYRZR6lBuspUlPow1nXwPVUZHdyyxf1Y2KVo+PwW1A/n5
         mHRSfLC8bXeeflF32yHHLIoy5SrVBrMtDh73U+eESoUqiILoPmjIlItOWeNSojEwhJHW
         vDLi7GzltFrKZNeh3u1kMZpT+VWnle/lNxqHo=
Date: Mon, 15 Feb 2010 23:13:32 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Maarten Maathuis <madman2003@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       nouveau@lists.freedesktop.org
Subject: Re: [git pull] drm
Message-ID: <20100215221332.GB3332@joi.lan>
References: <alpine.DEB.2.00.1002110417200.516@skynet.skynet.ie>
 <201002151053.48681.borntraeger@de.ibm.com>
 <20100215201201.GA3332@joi.lan>
 <6d4bc9fc1002151239x2b994ea9l7f868d9bb8f789e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d4bc9fc1002151239x2b994ea9l7f868d9bb8f789e9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 09:39:00PM +0100, Maarten Maathuis wrote:
> The channel/context switch lock related patches (to the best of
> knowledge) haven't even gone outside the nouveau tree, so the initial
> damage isn't even there. At least not for the first path. As for the
> 2nd patch, that one was squished into the original patch for this pull
> iirc.

Ouch, you are right.
Sorry for the noise.

Marcin

