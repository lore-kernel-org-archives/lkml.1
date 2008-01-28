Return-Path: <linux-kernel-owner+w=401wt.eu-S1762550AbYA1Vcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbYA1Vcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 16:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbYA1Vc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 16:32:28 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47100 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYA1Vc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 16:32:27 -0500
Date: Mon, 28 Jan 2008 13:49:23 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
In-reply-to: <20080128205441.GA13442@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joachim Deguara <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Dean Roe <roe@cray.com>
Message-id: <200801281349.24303.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801281211.28214.joachim.deguara@amd.com>
 <20080128205441.GA13442@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 12:54:41 pm Ingo Molnar wrote:
> 
> * Joachim Deguara <joachim.deguara@amd.com> wrote:
> 
> >     x86: add PCI IDs to k8topology_64.c
> >     
> >     This just adds the PCI IDs of AMD's family 10h and 11h CPU's 
> >  northbridges to k8topology discovery.
> 
> thanks Joachim, applied.

thanks.

I used it with my local patches for supporting family 10h with acpi=off pci=nomsi for a while.

YH
