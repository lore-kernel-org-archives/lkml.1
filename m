Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZCMCxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZCMCxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZCMCxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:53:32 -0400
Received: from kroah.org ([198.145.64.141]:50424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752840AbZCMCxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:53:31 -0400
Date: Thu, 12 Mar 2009 19:50:51 -0700
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jarod Wilson <jarod@wilsonet.com>, LMML <linux-media@vger.kernel.org>
Subject: Re: [stable] Fwd: [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
	video_open
Message-ID: <20090313025051.GA5385@kroah.com>
References: <200902241700.56099.jarod@redhat.com> <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 04:24:38PM -0400, Michael Krufky wrote:
> Can we have this merged into -stable?  Jarod Wilson sent this last
> month, but he left off the cc to stable@kernel.org

What is the git commit id of the patch in Linus's tree that matches up
with this?

thanks,

greg k-h
