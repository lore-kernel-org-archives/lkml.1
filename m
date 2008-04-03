Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYDCMLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYDCMLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYDCMLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:11:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYDCMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R2VyKjuzaawVqvV1xP7AfN0o4hprhVng0JW82/ZgJFtsO3lqAsWVDiO6HV1U3kBTUAtGND+MWaHHQuM1BvXKs57AWi/fbts6ZQlTB0ZY+uKe5c7PbHPHmxqAyzSX1WYBQpBDFcjYEX10xuSXbkEY4uQr/H55Zf416QZNn3cN4co=
Message-ID: <21d7e9970804030511w64232e65x822c72d70707ef6@mail.gmail.com>
Date: Thu, 3 Apr 2008 22:11:30 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc8-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 2:32 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
>
>  - Added the wm97xx touchscreen driver tree, as git-wm97xx.patch (Mark Brown
>   <broonie@opensource.wolfsonmicro.com>)
>
>  - git-alsa.patch has been replaced by git-alsa-tiwai.patch
>
>  - git-drm.patch is dropped due to build errors
>
Actually git-agp.patch is broken, and should have been dropped. the
drm patch is fine.

I did mention this to you in two separate e-mails :)

Dave.
