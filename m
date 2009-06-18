Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbZFROGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbZFROGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZFROFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:05:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZFROFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:05:54 -0400
Date: Thu, 18 Jun 2009 10:05:51 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slqbinfo doesn't exist...
Message-ID: <20090618140551.GA1881@bombadil.infradead.org>
References: <20090617183851.GA15429@bombadil.infradead.org> <20090618011532.GA19732@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618011532.GA19732@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 09:15:32AM +0800, Wu Fengguang wrote:
> Hi Kyle,
> 
> On Thu, Jun 18, 2009 at 02:38:51AM +0800, Kyle McMartin wrote:
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > Commit 35efa5e993a7a00a50b87d2b7725c3eafc80b083 which added a page-types
> > tool introduced a reference to slqbinfo in the Makefile, which, doesn't
> > exist... This is currently causing my rawhide builds to fail.
> 
> This fix should be in the latest git tree. Sorry for all the inconvenience!
> 

Yup, I saw. All good.


Thanks!
	Kyle
