Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbXKBHDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbXKBHDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 03:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXKBHDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 03:03:45 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:54569 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXKBHDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 03:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T0hConYtYZLVguPz3+6IuopACCAYxekYdVJCdKBrcB204h12qjtejp7T5WBkyYa28I/LzfRgi0+B8gmtxDOYpiZcmue2ylcVap2447iJET3lFIS9UC2l5+cnp+WHmGe08Yyt5lT3bzIO/hSDfwykJ3qaBQRhpnA9OJSZ0s93eGU=
Message-ID: <386072610711020003j2723888ep380cf4792e94e08d@mail.gmail.com>
Date: Fri, 2 Nov 2007 15:03:43 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Bharata B Rao" <bharata.rao@gmail.com>
Subject: Re: [PATCH 6/7] d_path: Make d_path() use a struct path
Cc: "Jan Blunck" <jblunck@suse.de>,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@lst.de>,
       "Andreas Gruenbacher" <agruen@suse.de>
In-Reply-To: <344eb09a0711012345p1d6bd667s52ef38f3185b478@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029124120.528997881@weierstrass.suse.de>
	 <20071029124121.829255433@weierstrass.suse.de>
	 <344eb09a0711012345p1d6bd667s52ef38f3185b478@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Bharata B Rao <bharata.rao@gmail.com> wrote:
> On 10/29/07, Jan Blunck <jblunck@suse.de> wrote:
> >
> >
>
> Did you miss the d_path() caller arch/blackfin/kernel/traps.c:printk_address() ?
>

Yes, I remember I saw that before.
Please send patch again.
-Bryan Wu
