Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXCNLSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXCNLSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXCNLSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:18:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:32272 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120AbXCNLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VBgnjgHxlA6VSZZfzBmwij6aK1byxy4jrkHjRQJPZ0AfiXrcyFA+5BvqrMKP4xY8YXhYRsS0BzfGDGNkmag3kuNNGRTy9ufnbcPC2wk/aCG0bb3B4TI5MbXCixzBVlhC5kvk2wSGfNSwqT11iKcyE8LGe180b5Sns57a0wrpzbg=
Message-ID: <84144f020703140418r10bc4deft221c19a6fab6c1da@mail.gmail.com>
Date: Wed, 14 Mar 2007 13:18:45 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Chris Rankin" <rankincj@yahoo.com>
Subject: Re: [BUG] Linux 2.6.20.2 - unable to handle kernel paging request - still accessing freed memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <170606.12059.qm@web52911.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170606.12059.qm@web52911.mail.yahoo.com>
X-Google-Sender-Auth: 0f11f138d5480593
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 3/10/07, Chris Rankin <rankincj@yahoo.com> wrote:
> It looks like 2.6.20.2 is still doing Bad Things in /sys.

I have seen other reports of this too so can you please open a bug at
bugzilla.kernel.org so this is not lost in the noise?
