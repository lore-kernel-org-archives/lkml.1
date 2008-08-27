Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYH0U3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYH0U3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYH0U31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:29:27 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:36518 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYH0U30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:29:26 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
Date: Wed, 27 Aug 2008 21:29:15 +0100
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200807241732.23412.trenn@suse.de>
In-Reply-To: <200807241732.23412.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808272129.16131.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Wed, 27 Aug 2008 20:29:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 16:32:22 Thomas Renninger wrote:
> \section{WMI - Windows Management Instrumentation}
>
> WMI is a Microsoft specific service. A small part of it
> describes possible ACPI WMI implementations provided by the BIOS.
> This is not part of the official ACPI specification and BIOS developers
> should avoid using it. The Linux kernel driver supports basic WMI ACPI
> functionality (since 2.6.25), but it is marked experimental.
> ACPI functionality should not depend on the WMI interface.

Perhaps it would be more useful to suggest to vendors/ BIOS writers what they 
should use here instead?

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
