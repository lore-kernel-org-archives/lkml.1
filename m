Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYIQJiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYIQJiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYIQJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:38:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:56057 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYIQJiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lTMbJzH7w4r3Tan3zCBrwavdz5HjH3W869GfLj7gtEZd487hNFOd8kS0co/oi7rtOS
         97jhzOEECYyj2uymN40kHnM2kEg/0/d6mNAlJCFp/Eerxd+FetiMzPOiNbLrKWOB7ywr
         GPlX7HcyIr8OD/dqllNonAACNPAJE9mTysJd0=
Date: Wed, 17 Sep 2008 13:38:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: j_kernel@hoblitt.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080917093813.GB7455@lenovo>
References: <20080917024312.GA23209@hoblitt.com> <20080917071357.GA7455@lenovo> <20080917092058.GB23209@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917092058.GB23209@hoblitt.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[j_kernel@hoblitt.com - Tue, Sep 16, 2008 at 11:20:58PM -1000]
| On Wed, Sep 17, 2008 at 11:13:57AM +0400, Cyrill Gorcunov wrote:
| > Joshua, could you please attach ACPI tables dump to the bugzilla entry (~300K)?
| 
| Done but I was unable to extract the DSDT table as described in the
| instructions.
| 
| #  acpixtract DSDT < acpidump.asc           
| Could not open DSDT
| 
| Cheers,
| 
| -J
| 

 it's enough, thanks!

		- Cyrill -
