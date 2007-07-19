Return-Path: <linux-kernel-owner+w=401wt.eu-S940013AbXGSQuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940013AbXGSQuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764159AbXGSQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:49:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:42841 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761850AbXGSQt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:49:56 -0400
Date: Thu, 19 Jul 2007 18:49:53 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Don Zickus <dzickus@redhat.com>
Cc: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>, vgoyal@in.ibm.com,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070719164953.GA5381@suse.de>
Mail-Followup-To: Don Zickus <dzickus@redhat.com>,
	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>, vgoyal@in.ibm.com,
	Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>
References: <20070716123633.GA10920@in.ibm.com> <20070718230740oomichi@mail.jp.nec.com> <20070719163915.GN9623@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070719163915.GN9623@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Don Zickus <dzickus@redhat.com> [2007-07-19 18:39]:
> 
> I am not a big fan of this approach as it forces distros to require
> kexec-tools when building a kernel.  Even Joe Hacker who wants a custom
> kernel (and not interested in kexec) would have to not only download the
> kernel.src.rpm but kexec-tools just to build a kernel that probably
> doesn't have kexec enabled.

He would have to download makedumpfile, not kexec-tools.


Thanks,
   Bernhard
