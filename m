Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZLGJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZLGJIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbZLGJIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:08:17 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:40718 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZLGJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:08:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Yfal/+s8H/jmFtcFNW5hV59lp5bHS4lnE6nLuEkyfWy7z3K7+a18v6UC5gatpUwG/P
         q89O9aBDPJ/xVu0B1vR0t37id/fkKsPFem/FiKRhwhjP0f6rkmjj10hsc3hCyPhi7SXE
         SmQgad2VFKQLjHG+Kk+6GtmrYIXFhM8tkvIAQ=
MIME-Version: 1.0
In-Reply-To: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
References: <1260132388-28414-1-git-send-email-thellstrom@vmware.com>
Date: Mon, 7 Dec 2009 19:08:22 +1000
Message-ID: <21d7e9970912070108g2d9f17f3p6a299ea4e01587f2@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add TTM functionality and drm exports for vmwgfx
From: Dave Airlie <airlied@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 6:46 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> This patch series adds TTM functionality and a couple of drm exports needed by the
> vmwgfx drm driver. The patch adding the vmwgfx driver itself will be posted
> later. The current driver source is available at
>
> git://git.freedesktop.org/git/mesa/vmwgfx

Applied all of these to drm-core-next,

Thanks,
Dave.
