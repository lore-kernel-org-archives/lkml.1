Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZCCG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZCCG2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZCCG2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:28:06 -0500
Received: from kroah.org ([198.145.64.141]:42790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbZCCG2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:28:04 -0500
Date: Mon, 2 Mar 2009 22:27:21 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
	tree"
Message-ID: <20090303062721.GA4091@kroah.com>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 09:43:26PM -0800, Luis R. Rodriguez wrote:
> While extending the documentation for submitting Linux wireless bug
> reports [1] we note the stable series policy on patches -- that of
> having an equivalent fix already in Linus' tree. I find this
> documented in Documentation/stable_kernel_rules.txt but I'm curious if
> there is any other resource which documents this or elaborates on this
> a bit more.

Simple is better, do you really want a longer version of that same file?

Is there something confusing in it?

And as always, a simple:
	Cc: stable <stable@kernel.org>
in the patch itself is the easiest way to get it automatically included
in the next -stable releases after it hits Linus's tree.

What more do people want?  Personal invitations?

Is it time to break out the caligraphy pens and wax seals?

thanks,

greg k-h
