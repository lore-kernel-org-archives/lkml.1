Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZFTF64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZFTF64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbZFTF6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:58:49 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:57664 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZFTF6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MmSpIdlPRdeBzQ10aqWk+TTLIERD7rSrvQQncIrXq2puMvP27E+YCBO88rtQlI16Tk
         SZfWFWTIOh8w0sCtxCF2EMEgt1ZwFt7XOsyniFL0E0EzW1JK9sNUkDusKyhK1VOp0Sah
         BMiZTL0Z6Ml7l/SR82OKIeQKT/w+LZd1zxCxY=
MIME-Version: 1.0
In-Reply-To: <m1bpojv4wz.fsf@fess.ebiederm.org>
References: <4A329CF8.4050502@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	 <4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	 <4A3AC0C4.6060508@goop.org>
	 <86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
	 <4A3B5FCD0200007800006AC0@vpn.id2.novell.com>
	 <m1my84bpuq.fsf@fess.ebiederm.org>
	 <86802c440906192058v78746acft161d74720c01a6a7@mail.gmail.com>
	 <m1bpojv4wz.fsf@fess.ebiederm.org>
Date: Fri, 19 Jun 2009 22:58:51 -0700
Message-ID: <86802c440906192258p5af259d5r587cba28de0f77f2@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs 
	justbecause there's no local APIC
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Len Brown <lenb@kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 10:40 PM, Eric W.
Biederman<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>
> I'm curious what kind of pcie card do you have plugged in?  Looks like
> you have a irq or two per cpu.

intel 10g or sun neptune 10g

YH
