Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYBKDjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYBKDjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 22:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYBKDjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 22:39:01 -0500
Received: from testure.choralone.org ([194.9.77.134]:42056 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYBKDi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 22:38:59 -0500
X-Greylist: delayed 2999 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 22:38:59 EST
Date: Sun, 10 Feb 2008 21:48:35 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: [PATCH 1/4] cpufreq: change cpu freq tables to per_cpu
	variables
Message-ID: <20080211024835.GD26696@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Mike Travis <travis@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
	Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
References: <20080208233738.108449000@polaris-admin.engr.sgi.com> <20080208233738.292421000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208233738.292421000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:37:39PM -0800, Mike Travis wrote:
 > Change cpu frequency tables from arrays to per_cpu variables.
 > 
 > Based on linux-2.6.git + x86.git

Looks ok to me.   Would you like me to push this though cpufreq.git,
or do you want the series to go through all in one?

	Dave

-- 
http://www.codemonkey.org.uk
