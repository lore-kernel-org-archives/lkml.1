Return-Path: <linux-kernel-owner+w=401wt.eu-S1767582AbXDFKzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767582AbXDFKzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXDFKzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:55:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXDFKzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:55:48 -0400
Date: Fri, 6 Apr 2007 06:46:01 -0400
From: Dave Jones <davej@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Adrian Bunk <bunk@stusta.de>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [2.6 patch] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
Message-ID: <20070406104601.GA30225@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Adrian Bunk <bunk@stusta.de>, davej@codemonkey.org.uk,
	cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20070406101928.GB29169@stusta.de> <20070406102914.GA27372@redhat.com> <Pine.LNX.4.64.0704060637400.26474@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704060637400.26474@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 06:38:25AM -0400, Robert P. J. Day wrote:
 > On Fri, 6 Apr 2007, Dave Jones wrote:
 > 
 > > On Fri, Apr 06, 2007 at 12:19:28PM +0200, Adrian Bunk wrote:
 > >  > This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
 > >  >
 > >  > Signed-off-by: Adrian Bunk <bunk@stusta.de>
 > >  > Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 > >
 > > lets kill this in 2.6.22
 > 
 > given that there's no way this is going to make it into 2.6.21, isn't
 > that what adrian is proposing here?

even if so, it's a little premature. Lets get 2.6.21 out the door first.

	Dave

-- 
http://www.codemonkey.org.uk
