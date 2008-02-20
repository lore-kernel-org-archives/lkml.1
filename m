Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbYBTPg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbYBTPg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765765AbYBTPcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:32:54 -0500
Received: from hs-out-0708.google.com ([64.233.178.248]:21089 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760826AbYBTPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RZJ5Pc3KxUDIIAluw9jiwbXGGS4BCr2FvKbffZTLB7x2eXownhaD/pO76OJLaXaEs3Zg8uyc8Fnk+7sCohp8R9QvVO8B/pP+QcxV2Uyupb8A5tInVshf+MPGC6qn6Refk9xY2DfCi2bFkh/N2wj1hn5Tjk1Ru0gPKkLWWYZncbQ=
Message-ID: <87f94c370802200732g594a4f01jeba7d05579625ee2@mail.gmail.com>
Date: Wed, 20 Feb 2008 10:32:50 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Mark Lord" <mlord@pobox.com>
Subject: Re: hdparm-8.2 now available
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       ballen@gravity.phys.uwm.edu, "Ric Wheeler" <ric@emc.com>
In-Reply-To: <47BA21F0.90405@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BA21F0.90405@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

What kernel level is needed to support the new -N arg?

Tried it on a Suse 2.6.22 kernel (possibly not patched with all the
current security updates).

Failed with:

The Running Kernel Lack CONFIG_IDE_TASK_IOCTL Support.

Thanks
Greg

On Mon, Feb 18, 2008 at 7:25 PM, Mark Lord <mlord@pobox.com> wrote:
> hdparm for SATA/PATA has now been updated to version 8.2.
>
>  Upgrading is strongly recommended for all users.
>  This version fixes several bugs in earlier 7.x/8.x releases
>  that could cause issues when advanced features are attempted
>  on devices being driven by the old drivers/ide subsystem.
>
>  libata devices were unaffected, but drivers/ide devices could
>  misbehave or even be corrupted by some operations.
>
>  hdparm-8.2 is available at http://sourceforge.net/projects/hdparm/
>
>  Upgrading from any earlier 7.x or 8.x version
>  is strongly recommended for all users.
>
>  Cheers
>  --
>  Mark Lord
>  Real-Time Remedies Inc.
>  mlord@pobox.com
>  -
>  To unsubscribe from this list: send the line "unsubscribe linux-ide" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
