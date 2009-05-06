Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZEFAvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZEFAvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZEFAvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:51:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:56479 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZEFAvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:51:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,300,1239001200"; 
   d="scan'208";a="512842704"
Date: Wed, 6 May 2009 08:51:02 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Subject: Re: kexec defunct -- sd-async-shutdown [mmotm 2009-04-30-17-55]
Message-ID: <20090506005101.GA25287@sli10-desk.sh.intel.com>
References: <200905010114.n411EV3X022247@imap1.linux-foundation.org> <4A000891.3070109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A000891.3070109@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 05:36:17PM +0800, Jiri Slaby wrote:
> On 05/01/2009 02:55 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-04-30-17-55 has been uploaded to
> ...
> > sd-async-shutdown.patch
> 
> Hi,
> 
> this one causes kexec to hang.
Can you give more info about the hang, like the log? Is patch
synchronize-device-shutdown.patch applied? kexec takes the same way
to shutdown device, so does shutdown work in the system?

Thanks,
Shaohua
