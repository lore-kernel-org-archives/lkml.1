Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZATEbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZATEbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 23:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZATEbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 23:31:10 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44108 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZATEbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 23:31:09 -0500
X-Greylist: delayed 1089 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 23:31:09 EST
Date: Tue, 20 Jan 2009 15:12:58 +1100
From: Simon Horman <horms@verge.net.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090120041256.GB3200@verge.net.au>
References: <20090119212127.GA13157@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119212127.GA13157@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 04:21:27PM -0500, Neil Horman wrote:
> Hey all-
> 	It would be nice to be able to extract the dmesg log from a vmcore file
> without needing to keep the debug symbols for the running kernel handy all the
> time.  We have a facility to do this in /proc/vmcore.  This patch adds the
> log_buf and log_end symbols to the vmcoreinfo area so that tools (like
> makedumpfile) can easily extract the dmesg logs from a vmcore image.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

THis sounds reasonable to me.

-- 
Simon Horman
  VA Linux Systems Japan K.K., Sydney, Australia Satellite Office
  H: www.vergenet.net/~horms/             W: www.valinux.co.jp/en

