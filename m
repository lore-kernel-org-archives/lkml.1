Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYIKQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYIKQp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYIKQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:45:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYIKQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:45:45 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>, Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <1221151165.6309.55.camel@californication>
References: <48C68507.6000609@suse.com>
	 <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com>  <20080911134042.GB3293@kroah.com>
	 <1221151165.6309.55.camel@californication>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 09:45:38 -0700
Message-Id: <1221151538.8593.36.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 18:39 +0200, Marcel Holtmann wrote:
> What is wrong with moving the firmware into its own package with its
> own version number?

Nothing. You can do this today, building from the linux-firmware
repository. That repository is starting to contain extra firmware that
vendors are now willing to let us distribute -- where they _weren't_
willing to let us distribute it as part of the kernel.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

