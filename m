Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXDSADL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXDSADL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993021AbXDSADK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:03:10 -0400
Received: from ellpspace.math.ualberta.ca ([129.128.207.67]:36426 "EHLO
	ellpspace.math.ualberta.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030522AbXDSADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:03:08 -0400
Date: Wed, 18 Apr 2007 18:01:50 -0600
From: Michal Jaegermann <michal@ellpspace.math.ualberta.ca>
To: Len Brown <lenb@kernel.org>
Cc: Denis Kirjanov <kirjanov@gmail.com>,
       Marat Buharov <marat.buharov@gmail.com>,
       Marc Donner <Marc.Donner@dbd-breitband.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20.6 vanilla does't boot
Message-ID: <20070419000150.GA8797@ellpspace.math.ualberta.ca>
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com> <a872555b0704130438p602b8acbg520871d692266309@mail.gmail.com> <20070415155016.GA14489@ellpspace.math.ualberta.ca> <200704181539.26105.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704181539.26105.lenb@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 03:39:25PM -0400, Len Brown wrote:
> On Sunday 15 April 2007 11:50, Michal Jaegermann wrote:
> > 
> > A kernel derived from 2.6.21-rc6-git1 (2.6.20-1.3053.fc7.x86_64 from
> > Fedora "rawhide" to be more precise) did boot on the hardware in
> > question, though; but only when I gave it 'acpi=off'.  Without that
> > parameter it was getting stuck apparently when starting hotplug.
> > In that kernel case disks were accessed using pata_atiixp driver.
> 
> If "acpi=off" is necessary to boot the latest kernel, please
> report an ACPI bug:
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

I now travel and what I can do at this moment is somewhat limited.
In particular I cannot gain an access to the hardware in question.
But please see
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=232490
and the most recent comments there in particular.

> Please mention in the bug report what the latest working kernel was.

This is mentioned in the referenced report as well.

    Michal
