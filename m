Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZGCQAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZGCQAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZGCQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:00:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZGCQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:00:45 -0400
Date: Fri, 3 Jul 2009 12:00:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: wait up to 5 minutes for device connection
Message-ID: <20090703160046.GA4262@infradead.org>
References: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246626771-11345-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 03:12:51PM +0200, Paolo Bonzini wrote:
> Increases the device timeout from 10s to 5 minutes, giving the user a visual
> indication during that time in case there are problems.  The patch is a
> backport of changesets 144, 146, 150 and 909 in the Xenbits tree.

Why would it take 5 minutes to wait for a device?

