Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbYBDVgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbYBDVgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYBDVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:36:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:55874 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYBDVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:36:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TzcadCefXKt7AxZIoA4ww+WM4obpb1KXPjzqwiE/c3KLAqqrQV7N4reHiBclRc0yplUBMna2C9V5YhG2wzFJ9LfhBboNgPPulEhJfm8pnQUBiEMaQsYpBXBhU9J0ptnanmbX1uA3vqjXOG9n9F7m7WkIbGLqPc/M2kQZCHxu0cU=
Message-ID: <6101e8c40802041336r6da626dfv70bda527edb891da@mail.gmail.com>
Date: Mon, 4 Feb 2008 22:36:36 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Chris Wright" <chrisw@sous-sol.org>
Subject: Re: {2.6.22.y} CVE-2007-6434
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       "Greg KH" <gregkh@suse.de>, "Willy Tarreau" <w@1wt.eu>,
       "Adrian Bunk" <bunk@kernel.org>, "Nick Piggin" <npiggin@suse.de>
In-Reply-To: <20080204213406.GX28947@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
	 <20080204213406.GX28947@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, thanks

On 2/4/08, Chris Wright <chrisw@sous-sol.org> wrote:
> * Oliver Pinter (oliver.pntr@gmail.com) wrote:
> > mainline: ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
> >
> > --->8---
> > commit ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
> > Author: Eric Paris <eparis@redhat.com>
> > Date:   Tue Dec 4 23:45:31 2007 -0800
> >
> >     VM/Security: add security hook to do_brk
> >
> >     Given a specifically crafted binary do_brk() can be used to get low
> pages
> >     available in userspace virtual memory and can thus be used to
> circumvent
> >     the mmap_min_addr low memory protection.  Add security checks in
> do_brk().
>
> All of the low mmap addr stuff isn't added until 2.6.23.
>
> thanks,
> -chris
>


-- 
Thanks,
Oliver
