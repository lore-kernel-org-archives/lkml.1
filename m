Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYJXXZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYJXXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYJXXZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:25:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40289 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYJXXZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:25:16 -0400
Date: Sat, 25 Oct 2008 00:25:03 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Dong-Jae Kang <baramsori72@gmail.com>
Cc: balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       corsetproject@googlegroups.com,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [Question] power management related with cgroup based resource management
Message-ID: <20081024232503.GA20140@srcf.ucam.org>
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com> <4901B5C2.9070108@linux.vnet.ibm.com> <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 09:24:21PM +0900, Dong-Jae Kang wrote:

> I am interested in power management in server side.
> and I just wonder this question, "Is there any related point between
> cgroup framework and power management?"

Not currently, though it would certainly be possible to use cgroups as a 
mechanism for providing application-specific power management.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
