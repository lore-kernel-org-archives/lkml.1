Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbYEBOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbYEBOtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYEBOtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:49:41 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:39103 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYEBOtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=upqzhhGRunmuFR2qpBpGrI81d5ff/t2hjH6rqviX5pD2OjDUSSLxqe26sIisMNDSxcqbK99LH+AfcnrVaVzzuKAQnFPO+0ljsTCr0wbPJGnGgHFhtK19YTkGttzUR6RrsZG2q3CkKvdEWqeFBMT2x4KHhth/q4uFHOhUqGglaWU=
Message-ID: <84144f020805020749r55d5bd3eta82b5cdadb5fffea@mail.gmail.com>
Date: Fri, 2 May 2008 17:49:38 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: LogFS merge
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@osdl.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       "Christoph Hellwig" <hch@lst.de>, "Al Viro" <viro@zeniv.linux.org.uk>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080502133234.GA24080@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080502133234.GA24080@logfs.org>
X-Google-Sender-Auth: 4bfc6862bfa6474b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,

On Fri, May 2, 2008 at 4:32 PM, Jörn Engel <joern@logfs.org> wrote:
>  not being familiar with either maintaining my own git tree or the -next
>  process, I'd still like to get logfs into mainline.  It has gone through
>  six rounds of reviews and the last has been mostly about crossing some
>  i's here and dotting some t's there.
>
>  So should it simmer in -next and -mm for another month?  Should it go
>  straight into -linus?

You probably want an ACK from the VFS maintainers before aiming at
mainline. But it surely makes sense to ask Andrew to pull it in -mm
now.
