Return-Path: <linux-kernel-owner+w=401wt.eu-S1422910AbXBAOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422910AbXBAOY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXBAOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:24:27 -0500
Received: from dtp.xs4all.nl ([80.126.206.180]:53591 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1422903AbXBAOY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:24:26 -0500
Date: Thu, 1 Feb 2007 15:24:25 +0100
From: Erik Mouw <erik@harddisk-recovery.com>
To: Seetharam Dharmosoth <seetharam_kernel@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@linux-foundation.org
Subject: Re: Need all the patche from kernel-2.6.7 to kernel-2.6.19 related to VM
Message-ID: <20070201142424.GF29212@harddisk-recovery.com>
References: <241360.8627.qm@web7702.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241360.8627.qm@web7702.mail.in.yahoo.com>
Organization: Harddisk-recovery.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 04:40:42AM +0000, Seetharam Dharmosoth wrote:
> Can you please suggest me from where do I get the VM
> patches from kernel2.6.7 to kernel-2.6.19?

Untar linux-2.6.7 and 2.6.19 and run a diff against the mm directory in
each tree.

Or if you have git: "git diff ..v2.6.19 mm/" . Only disadvantage is
that it will give you only the diff from 2.6.11.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
