Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZDFRIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZDFRIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZDFRH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:07:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbZDFRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:07:56 -0400
Date: Mon, 6 Apr 2009 13:06:34 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jeff@garzik.org,
       jj@chaosbits.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Make CONFIG_SLOW_WORK an automatic rather than manual
	config option
Message-ID: <20090406170634.GB16787@bombadil.infradead.org>
References: <20090406144725.19407.16817.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406144725.19407.16817.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 03:47:25PM +0100, David Howells wrote:
> Make CONFIG_SLOW_WORK an automatic rather than manual config option so that
> people configuring their kernels don't have to make the choice.  It can be
> selected automatically by those things that require it (such as FS-Cache).
> 

Thanks, I had the damndest time figuring out if this was appropriate
for rawhide. :)

