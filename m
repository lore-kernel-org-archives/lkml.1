Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZGVFrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZGVFrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbZGVFrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:47:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48394 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZGVFrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:47:41 -0400
Date: Tue, 21 Jul 2009 22:47:39 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ACPI power meter driver?
Message-ID: <20090722054739.GC20171@plum>
Reply-To: djwong@us.ibm.com
References: <20090721234957.GB20171@plum> <1248225507.2670.2.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248225507.2670.2.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:18:27AM +0800, Zhang Rui wrote:
> On Wed, 2009-07-22 at 07:49 +0800, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > I noticed that section 10.4 of the ACPI 4.0 spec mentions exposing power meter
> > hardware via the DSDT.
> 
> right.
> 
> >   Is anybody currently writing a Linux driver for that
> > power meter interface?
> > 
> do you have an laptop with that implemented?
> can you attach the acpidump output please? :)

No, but I'm working on a prototype to send power use estimates to kvm guests.

Reading between the lines, you sort of imply that you are working on a driver?
If you are, we should coordinate efforts.

--D
