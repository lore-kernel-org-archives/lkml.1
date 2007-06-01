Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbXFAVDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbXFAVDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763185AbXFAVDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:03:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:47984 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763019AbXFAVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SVDbtklmL6ob/5BpQg43tN5M2w+IquwSuxoRUndxTd5XrrTMQgEwFpugVa99q7zBLSlrwx/FiAKU60x7B8jjVlZR3iFQyzq/WhRXj0z3ERs5LF1t677COK8dIpxnqZ8BD3aEfbuOCaMoorD7zleh7qQIrw3jXDrfzGJPKcKO/KU=
Message-ID: <b6a2187b0706011403p49805044q89ebe1a4204caa56@mail.gmail.com>
Date: Sat, 2 Jun 2007 05:03:27 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton LKML" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070601171003.GA3040@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46600F1C.5000302@googlemail.com>
	 <b6a2187b0706010628m3d9ffad5y9a76e22719f439b7@mail.gmail.com>
	 <6bffcb0e0706010923y5a2bc729x7388b60cc73d94f7@mail.gmail.com>
	 <b6a2187b0706010943w370f2d5ft4f16a49cc4161012@mail.gmail.com>
	 <20070601171003.GA3040@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/07, Sam Ravnborg <sam@ravnborg.org> wrote:

> The fix is in -mm and sent to Andi.
> So it will likely be merged soon.
>
> I recommemd to ignore the warnings for now.

Thanks, I'll check when the next rc4 is ready.

Jeff.
