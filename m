Return-Path: <linux-kernel-owner+w=401wt.eu-S1760823AbXEaE53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823AbXEaE53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbXEaE5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:57:12 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:59662 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbXEaE5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JLdNIFoALKXFHEjXA90aW0RmYjsJc+uxf5Cvtrv62Y781NmarIqQdIXQ+gYfxmcOcr5Q/RjpUH8yq8/S47ey1D8bkzffIDKDesalcDLpozzQBzqdyvSKRC7QNN+z2dWaraZNLYNdb/idd8u1jjZzLM/MaSNFaZ5/7ABpUzBwcis=
Message-ID: <21d7e9970705302157nad9012bob87a8e4bafab47d2@mail.gmail.com>
Date: Thu, 31 May 2007 14:57:09 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Dave Airlie" <airlied@linux.ie>
Subject: Re: [git pull] drm fixes for 2.6.22-rc3
Cc: torvalds@osdl.org, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705300234060.19669@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705300234060.19669@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Dave Airlie <airlied@linux.ie> wrote:
>
> Hi Linus,
>
> Please pull the 'drm-patches' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches
>
> It contains a fix for a kmalloc 0, along with new pci ids for the radeon rs480
> and a spinlock initialiser.
>
> I have stuff that actually fixes up the drm_drawable.c to use an idr but I'll hold until the next merge window.

Did this get pulled yet? the kmalloc 0 regression fix is important I assume..

Dave.
