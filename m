Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYBSX34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYBSX34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYBSX3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:29:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:34846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYBSX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:29:46 -0500
Date: Tue, 19 Feb 2008 15:25:15 -0800
From: Greg KH <gregkh@suse.de>
To: "Carlos E. M. Dyonisio" <cadu@nerdfeliz.com>
Cc: LKML <linux-kernel@vger.kernel.org>, balajirrao@gmail.com
Subject: Re: 2.6.25-rc2 regression: kobject handling in cpufreq doesn't
	allow the system to power off
Message-ID: <20080219232515.GA1963@suse.de>
References: <20080220102114.307a97a9.cadu@nerdfeliz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220102114.307a97a9.cadu@nerdfeliz.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:21:14AM +1100, Carlos E. M. Dyonisio wrote:
> Hi,
> 
> I'm using the latest Linus' git tree, and the bug with cpufreq not allowing
> the system to power off is still there.
> 
> With the patch sent some days ago (http://lkml.org/lkml/2008/2/8/346), it
> works fine. There is also a bugzilla entry for this bug here:
> http://bugzilla.kernel.org/show_bug.cgi?id=9960
> 
> Any ideas of when will this patch be going to mainline?
> 

I'll be sending it to Linus in a day or so.

thanks,

greg k-h
