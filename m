Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbYGXDpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbYGXDpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYGXDpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYGXDpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:45:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu =?iso-8859-1?q?with=09cpumask=5Fof=5Fcpu=5Fptr?=
Date: Thu, 24 Jul 2008 10:46:13 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080723112309.GA30519@elte.hu> <48873FA0.50504@sgi.com>
In-Reply-To: <48873FA0.50504@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241046.15632.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 00:26:40 Mike Travis wrote:
> Standby, the "generic" cpumask_of_cpu_map patch is coming... just testing
> now.

Thanks Mike, that's going to be a huge improvement in clarity.

Cheers,
Rusty.
