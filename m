Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYGSQ3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYGSQ3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYGSQ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:28:58 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:46627 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753137AbYGSQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:28:58 -0400
Date: Sat, 19 Jul 2008 12:28:56 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macbook2,2 latest git mmconfig issues
Message-ID: <20080719162856.GA14334@bromo.msbb.uc.edu>
References: <dd18b0c30807182039u3e590e50p5d76624dd9e5b1d8@mail.gmail.com> <86802c440807182145qa3d17e9k210c498109d86b58@mail.gmail.com> <dd18b0c30807182254i49de078bhe5e48ab13e7b01ac@mail.gmail.com> <dd18b0c30807182354h429ea664gb90b7de55608d0bd@mail.gmail.com> <20080719131038.GA13168@bromo.msbb.uc.edu> <dd18b0c30807190753q22259690jcae780de13c8560d@mail.gmail.com> <20080719151453.GA13792@bromo.msbb.uc.edu> <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30807190854w17059d63g10e1e199f855988b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 08:54:58AM -0700, Justin Mattock wrote:
> 
> >From over here; do you think grub
> has something to do with this error?
> why: when installing the intaller was broken
> thus having to download the latest grub and manually
> plug in the partitions and so forth.
>  when using the latest git(a day ago) I was using
> an older version it seems of grub. But this wouldn't explain
> why I received the PCI: not using MMCONFIG error
> I need right now to make sure the name is correct
> "MacBook2" and "Apple", and make sure 0x3f
> is right also. You never know maybe these get changed with
> each version of the mac's. Overall this is a pretty nasty bug
> leaving completely out of business.
> -- 
> Justin P. Mattock

Justin,
   The current tip from earlier this morning is booting fine under
Fedora 9 here on my MacBook Pro v2 (build with CONFIG_PCIEASPM unset).
I am rebuilding tip with CONFIG_PCIEASPM=y in case the issue is fixed
or has gone latent on tip. If not, I'll update my bugzilla and try
to get Jesse to take a look at it.
                     Jack

