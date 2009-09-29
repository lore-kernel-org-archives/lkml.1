Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZI2Q5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZI2Q5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZI2Q5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:57:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZI2Q5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:57:53 -0400
Message-ID: <4AC23B23.2050506@zytor.com>
Date: Tue, 29 Sep 2009 09:51:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Arjan van de Ven <arjan@infradead.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	 <20090919224430.GB9567@kroah.com>	 <1253419185.3253.21.camel@ank32.eng.vmware.com>	 <20090920074247.GA5733@elte.hu>	 <1253647845.10565.20.camel@ank32.eng.vmware.com>	 <4AB9CE66.1030504@redhat.com>	 <1254185107.13456.32.camel@ank32.eng.vmware.com>	 <20090929100831.18ece319@infradead.org> <1254242989.7803.11.camel@ank32.eng.vmware.com>
In-Reply-To: <1254242989.7803.11.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 09:49 AM, Alok Kataria wrote:
> 
> So, are you saying that we should be doing something else along with
> toggling it off in the Kconfig ? 
> We have already informed most of the distro folks about this deprecation
> so I think we should be okay there, but if there is something else that
> should be done, do let me know.
> 

I don't see it ever having been anything than off by default in Kconfig.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

