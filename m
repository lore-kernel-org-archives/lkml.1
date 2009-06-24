Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZFXVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZFXVAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZFXVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:00:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58430 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZFXVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:00:04 -0400
Date: Wed, 24 Jun 2009 21:59:56 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Joseph Cihula <joseph.cihula@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 0b/4] intel_txt: Intel(R) Trusted Execution
	Technology support for Linux - Details
Message-ID: <20090624205955.GA9632@srcf.ucam.org>
References: <4A4024B6.2060600@intel.com> <20090624201415.GA18291@redhat.com> <4A428E9D.7080509@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A428E9D.7080509@linux.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:37:49PM -0700, Arjan van de Ven wrote:
> Dave Jones wrote:
>> This seems a little disingenious.  Firmware isn't typically loaded by grub
>> into main memory and executed by the host processor.
>>
>> so, is this all worthless without the binary blob ?
>>
>> "trust us, it's signed by intel" doesn't make me feel more secure.
>
> how's that different from your normal bios ?

BIOSes can typically be replaced with trusted code. Is the source to the 
ACMs available? Is there any way for the owner of the machine to 
substitute their key for Intel's?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
