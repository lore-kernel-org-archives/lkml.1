Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYFDNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYFDNXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbYFDNWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:22:20 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:4132 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbYFDNWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=BJ6a3nweYUlZJSZKwJy4rearUk8os3bNgxIfwQ7YwDot/K0j/nqIOmJip8UWGn2uU2
         zMvgDcTIg7wZ58ttyu6uejcOj2Y2Zj4GZF3TCnjP9vAepB9y159Bzisx63UbYkEGlQPP
         nF8bP3HzrS0ucx7rX2iHSfckwYJWVlDu/K3RU=
Message-ID: <517f3f820806040622j5a5b4cb0m9baacbc4ad79c779@mail.gmail.com>
Date: Wed, 4 Jun 2008 15:22:17 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 0/4 v2] vfs: fix utimensat() non-conformances to spec
Cc: lkml <linux-kernel@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>,
       "Miklos Szeredi" <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       jamie@shareable.org, "Ulrich Drepper" <drepper@redhat.com>,
       linux-fsdevel@vger.kernel.org,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>
In-Reply-To: <484694C1.7030603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484694C1.7030603@gmail.com>
X-Google-Sender-Auth: e95736cafb50d42b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  This patch series is a revised version of the patch series
>  that I sent yesterday to fix various utimensat()
>  non-conformances.  Patches 1 and 2 are unchanged (and were
>  Acked by Miklos); patches 3 and 4 are revised following
>  comments by Miklos.

D'oh!  I left the "v2" markers off the resent patchs 1 and 3, so they
got the same subject lines as yesterday's versions.  Sorry about that!
