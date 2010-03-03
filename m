Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0CCHsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:48:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab0CCHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:48:15 -0500
Date: Wed, 3 Mar 2010 02:48:14 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] ceph: nfs re-export support
Message-ID: <20100303074814.GA1030@infradead.org>
References: <1267577217-31923-1-git-send-email-sage@newdream.net> <1267577217-31923-24-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267577217-31923-24-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:46:54PM -0800, Sage Weil wrote:
> Basic NFS re-export support is included.  This mostly works.  However,
> Ceph's MDS design precludes the ability to generate a (small)
> filehandle that will be valid forever, so this is of limited utility.

So don't include it if it's broken by design.

