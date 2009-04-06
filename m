Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZDFVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZDFVMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbZDFVLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:43876 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZDFVLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=lUmfZg+YZTnqRwIF5zf3EaZ9Pj6RNdAU+o6eKKluaTDMVQKxMWeVIbpCb68O7yXx5p
         aP1wpBL6/sDSod+MhhyEi9uBglgnd704I0+RGhWiyC3NNg/o/3LnCMNiwmq8DtjsCepA
         6iJVfmJZo2SaVxyWMSdUlA2h9p7wQ4HTFLDNQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] tx493[89]ide: Remove big endian version of tx493[89]ide_tf_{load,read}
Date: Mon, 6 Apr 2009 22:58:19 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp>
In-Reply-To: <1239034146-3514-1-git-send-email-anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062258.20246.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Atsushi Nemoto wrote:
> Now tx493[89]ide_tf_{load,read} do not contain word I/O operations.
> They are endian-free now.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

applied
