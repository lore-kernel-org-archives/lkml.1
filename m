Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYL2GwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYL2GwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 01:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYL2GwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 01:52:12 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46284 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYL2GwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 01:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oksym6foRnrky/CSr5JOT23a2/l9YBY4owyYY0FfSEoWaACmkswCj7xaazW4vKbUDq
         TitG4Zqa8Zjy8ha0TLhloAoNTRQgPw1mFIDN2Myb3Gekk3CRmKWNpOOj8eNiNjp9FSir
         0bXM7aEHUxsbnAOZ1NJtq3/9t/6LxyYFgvOZ4=
Date: Mon, 29 Dec 2008 09:57:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229065713.GA10960@x200.localdomain>
References: <1230382948.3373.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230382948.3373.1.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 06:32:28PM +0530, Jaswinder Singh Rajput wrote:
> Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h

And this is done for what?
