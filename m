Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYIQJVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYIQJVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYIQJVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:21:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59073 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYIQJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:21:03 -0400
Date: Tue, 16 Sep 2008 23:20:58 -1000
From: j_kernel@hoblitt.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917092058.GB23209@hoblitt.com>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917071357.GA7455@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:13:57AM +0400, Cyrill Gorcunov wrote:
> Joshua, could you please attach ACPI tables dump to the bugzilla entry (~300K)?

Done but I was unable to extract the DSDT table as described in the
instructions.

#  acpixtract DSDT < acpidump.asc           
Could not open DSDT

Cheers,

-J

--
