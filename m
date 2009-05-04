Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbZEDWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbZEDWSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZEDWSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:18:22 -0400
Received: from kroah.org ([198.145.64.141]:50777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZEDWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:18:22 -0400
Date: Mon, 4 May 2009 15:09:05 -0700
From: Greg KH <greg@kroah.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
Message-ID: <20090504220905.GA29402@kroah.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 02:48:32PM -0700, Arve Hjønnevåg wrote:
> On Mon, May 4, 2009 at 9:35 AM, David Rientjes <rientjes@google.com> wrote:
> > Clean up the code in lowmem_shrink() for the Android low memory killer so
> > that it follows the kernel coding style.
> >
> 
> Do you mind applying the lowmemorykiller patches from the
> android-2.6.29 branch in
> git://android.git.kernel.org/kernel/common.git first. It already has
> some of this clean up.

Are these the patches already in my tree?

If so, David, just respin your patches against the linux-next tree and
resend them, that should be sufficient.

If not, Arve, can you send me your patches first?

David, in the future, can you cc: me anything under drivers/staging/ so
that I know to pick the patches up?

thanks,

greg k-h
