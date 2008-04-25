Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYDYW1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYDYW1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYDYW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:27:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbYDYW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:27:35 -0400
Date: Fri, 25 Apr 2008 15:30:27 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, oliver@neukum.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, zaitcev@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2 UPDATED] klist: implement KLIST_INIT() and
	DEFINE_KLIST()
Message-ID: <20080425223027.GA12643@kroah.com>
References: <480DB6A4.20101@gmail.com> <1208869049.7115.254.camel@twins> <480DE215.2070803@gmail.com> <1208869591.7115.263.camel@twins> <480DE3B3.6050702@gmail.com> <20080425163736.GC10397@kroah.com> <48121FE4.5010803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48121FE4.5010803@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:16:04AM +0900, Tejun Heo wrote:
> klist is missing static initializers and definition helper.  Add them.
>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
> Updated to use _name.k_lock as advised.

Thanks, was there a 2/2 patch in this series as well that I should be
applying?

greg k-h
