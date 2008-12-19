Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYLSPEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYLSPEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 10:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYLSPD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 10:03:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:28286 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYLSPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 10:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BAzF8nvc4FETPe4S40Gx0c5gBmozrbG7MIv4wPQR3yGm4KHlHUnu1iN79KPmrzm5/E
         lRnvymS/ERDI9O108AZQIwwxpfsmZel+AXd5CyWaXuIOBKoiTd0QEfb8/7KAvtWVwJL5
         zOJEPdmVM2fBxtSd4ClO2oZKL2ct568PfJ6+Q=
Message-ID: <e9e943910812190703w6fb43cebmfe96f2a2e8cc47dd@mail.gmail.com>
Date: Fri, 19 Dec 2008 15:03:52 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] vfs: introduce helper function to safely NUL-terminate symlinks
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Andreas Dilger" <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org
In-Reply-To: <e9e943910812161626i6f2cdc3eldc36c68e9a98f180@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229442720-31056-3-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-4-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-5-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-1-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-6-git-send-email-duaneg@dghda.com>
	 <1229442720-31056-2-git-send-email-duaneg@dghda.com>
	 <20081216234638.GX5000@webber.adilger.int>
	 <e9e943910812161626i6f2cdc3eldc36c68e9a98f180@mail.gmail.com>
X-Google-Sender-Auth: 64c6e78ad319284a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/17 Duane Griffin <duaneg@dghda.com>:
> It is true for sysv, too. The ufs code also, but that has other
> issues, anyway. The generic page symlink and freevxfs patches should
> be fine, though.

Before I fire off another set of patches, should I be sending out the
complete set again or just the ones that need to be updated?

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
