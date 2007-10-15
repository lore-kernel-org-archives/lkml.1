Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbXJOVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbXJOVNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbXJOVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:12:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:24259 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbXJOVMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XpICp1e4W1LXPwmt7YdHx1KVM3xaadaQ791YV7tuPPNw10ZHYoJbpI7yuwGpgMiWEDzAWnw+06TqmcpfkZ8OMbXc4G+j4J1iUFIX3STerhmxUAjxPGXK4cfeAn1I8oZIhX2kz0qBDUtBmzuaEWG0W+c1Nbj/0tdIiqkzXKPPLeM=
Message-ID: <d120d5000710151412s5381353bx4ac07529e5da2bc0@mail.gmail.com>
Date: Mon, 15 Oct 2007 17:12:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] Input updates for 2.6.24-rc0
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0710151341540.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710131614.35356.dmitry.torokhov@gmail.com>
	 <d120d5000710151328k6f413b76i21809691d9a18fe8@mail.gmail.com>
	 <alpine.LFD.0.999.0710151341540.6887@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 15 Oct 2007, Dmitry Torokhov wrote:
> >
> > *ping*
>
> Thanks, pulled and pushed out.
>
> Can you check that applesmc looks sane after the merge conflict? The
> conflict itself looked pretty trivial, and it compiles for me, but I'd
> still like somebody who knows those things to double-check..
>

Yep, it looks good from here.

Thanks.

-- 
Dmitry
