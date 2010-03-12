Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0CLPwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:52:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0CLPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:52:22 -0500
Date: Fri, 12 Mar 2010 07:07:50 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, avi@redhat.com,
       stable@kernel.org, stable-commits@vger.kernel.org
Subject: Re: patch kvm-x86-emulator-add-group8-instruction-decoding.patch
	added to 2.6.32-stable tree
Message-ID: <20100312150750.GB2817@suse.de>
References: <12683548383025@site> <4B99EBB9.5000508@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B99EBB9.5000508@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 08:22:33AM +0100, Stefan Bader wrote:
> Greg,
> 
> I am currently working on getting the whole series of kvm patches marked for
> stable backported to 2.6.32. You could pick those from
> 
> git://kernel.ubuntu.com/smb/linux-2.6.32.y.git kvm

Um, why pick them now, are they somehow not tested?

> Currently there is one patch on the HEAD which is fixing a regression for AMD
> hosts. That is not upstream, yet. (needed for the patch fixing memory access).

I'd like Avi, or Marcelo, to ack the patch set first, as they obviously
had some idea when they added the stable markings, yet, something went
wrong as they look to be adding new features and were totally not able
to be merged.

Avi, sound ok?

thanks,

greg k-h
