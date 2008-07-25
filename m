Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGYLUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGYLUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 07:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYGYLU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 07:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYGYLU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 07:20:28 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Len Brown <lenb@kernel.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Fri, 25 Jul 2008 13:20:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de> <alpine.LFD.1.10.0807241937500.6098@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0807241937500.6098@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251320.26213.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008 01:47:04 Len Brown wrote:
> It is not an ACPI specification violation that Linux
> (and ACPICA) claim compatibility with the interfaces
> advertised by one or multiple versions of Windows.
>
> Yes, there are be cases where BIOS vendors will want
> to know if the running version of Linux supports,
> or does not support, an interface/feature.

> We (the Linux community that maintain Linux/ACPI) are
> eager to support them in this.  However, the interface
> needs to be sufficiently defined so that we know when
> to _not_ advertise that feature.
>
> eg. There are proposals for
>
> _OSI("Linux-Needs ATI S3 video re-POST")
> _OSI("Linux-Needs NVIDIA S3 video re-POST")
> _OSI("Linux-Native IPMI Support")

Great!
Please add me to CC as soon as you agreed to something and
I'll pick those up.

Thanks,

       Thomas
