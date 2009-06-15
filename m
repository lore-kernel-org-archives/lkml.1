Return-Path: <linux-kernel-owner+w=401wt.eu-S1761937AbZFPBmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937AbZFPBmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 21:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZFPBml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 21:42:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZFPBml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 21:42:41 -0400
Date: Mon, 15 Jun 2009 22:47:48 +0800
From: "Li, Yan" <yanli@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, greg@kroah.com, yan.i.li@intel.com
Subject: Re: [PATCH] More i8042-reset quirks for MSI Wind-clone netbooks
Message-ID: <20090615144748.GA25734@thyme.bj.intel.com>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, greg@kroah.com, yan.i.li@intel.com
References: <20090615141613.GA7876@sage.bj.intel.com> <20090615143446.GB19451@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615143446.GB19451@srcf.ucam.org>
Organization: Intel
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <yanli@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 03:34:46PM +0100, Matthew Garrett wrote:
> On Mon, Jun 15, 2009 at 10:16:13PM +0800, Yan Li wrote:
> > When testing Moblin on various netbooks, we've got reports that many
> > MSI Wind clones need the i8042 reset quirks for the keyboard and/or
> > touchpad's proper function.
> 
> Why are we not doing this unconditionally?

For the majority of sane machines this is not necessary.

-- 
Li, Yan
