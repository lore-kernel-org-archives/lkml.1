Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYC2RPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYC2RPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYC2RPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:15:42 -0400
Received: from rtr.ca ([76.10.145.34]:3644 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbYC2RPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:15:41 -0400
Message-ID: <47EE793C.5070105@rtr.ca>
Date: Sat, 29 Mar 2008 13:15:40 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: bugme-daemon@bugzilla.kernel.org
Cc: rjw@sisk.pl, bunk@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [Bug 10345] USB HID problems after resume
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca>
In-Reply-To: <47EE78C9.5090006@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=10345
>
>
> rjw@sisk.pl changed:
>
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>              Status|NEW                         |REJECTED
>          Resolution|                            |UNREPRODUCIBLE
>
>
>
>
> ------- Comment #2 from rjw@sisk.pl  2008-03-28 15:35 -------
> Handled-By : Mark Lord <lkml@rtr.ca>
> References : http://lkml.org/lkml/2008/3/28/346
>
> Mark said:
>
> "Also, for now it seems to be "resolved" via a seemingly-unrelated
> change in the .config file on that machine.  If it dies again,
> I'll re-post and investigate further."
..

Just happened again.  The machine resumed from RAM with no functioning USB.
Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.

WTF?

