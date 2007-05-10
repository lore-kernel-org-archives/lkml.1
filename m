Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXEJQGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXEJQGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbXEJQG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:06:29 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:59720 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXEJQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=rT41c1x7GnZ78BznAV8aL/7eb4LES2I16RdRZD3cHkla5T9ZGp69vypsowtJUpw8yho04Vw8Gz+apTapwP35yK+h76gXnIDDNkr9QH1IhYsUXdtM83Mmx2OGZM5sTWLnZJ71NbEIhPN3evFrFHCXLvKKYxshVu2NgFZ5G/FqUlM=
Message-ID: <4643426B.1040207@gmail.com>
Date: Thu, 10 May 2007 18:03:55 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Bob Tracy <rct@gherkin.frus.com>
CC: Ondrej Zary <linux@rainbow-software.org>, Andrew Morton <akpm@osdl.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <20070508211236.95087DBA1@gherkin.frus.com>
In-Reply-To: <20070508211236.95087DBA1@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 11:12 PM, Bob Tracy wrote:

> Agreed.  I've still got a GUS in one of my museum pieces that runs MS-Win
> 3.1 by default.  The BIOS is too old to support booting from anything
> except hda, sda and floppy, but because I enjoy pain I'll be happy to
> modify the startup floppy images for a 2.6.X-based live CD distro (DSL,
> anyone?) and give the new drivers a spin when they're ready for testing.

Okay, thanks. Which drive(s) do you have? If mitsumi, the driver as posted 
is already functioning well for data. My LU005 drive is a single speed drive 
(150 K/s) but it's giving me close to 400 K/s. At the moment I also have it 
hanging of a GUS...

> The motherboard is a curiosity: it has ISA, PCI, *and* VLB slots.

Mmm. Never seen that...

Rene.
