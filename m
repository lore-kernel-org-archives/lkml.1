Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZITBFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZITBFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 21:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZITBFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 21:05:00 -0400
Received: from claw.goop.org ([74.207.240.146]:45903 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZITBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 21:04:59 -0400
Message-ID: <4AB57FB9.2020705@goop.org>
Date: Sat, 19 Sep 2009 18:04:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090919224430.GB9567@kroah.com>
In-Reply-To: <20090919224430.GB9567@kroah.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/09 15:44, Greg KH wrote:
> That sounds good to me, how intrusive are the patches to do this?  Is it
> going to be tricky to get everything merged properly in -tip for it?

They should be very local - just a matter of removing a couple of files
and dropping some config options.

    J
