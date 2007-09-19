Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXISR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXISR22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbXISR2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:28:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbXISR2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:28:16 -0400
Date: Wed, 19 Sep 2007 18:28:15 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
Message-ID: <20070919172815.GC20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182721.8EF73A09@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182721.8EF73A09@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:21AM -0700, Dave Hansen wrote:
> 
> I'm going to be modifying nfsd_rename() shortly to support
> read-only bind mounts.  This #ifdef is around the area I'm
> patching, and it starts to get really ugly if I just try
> to add my new code by itself.  Using this little helper
> makes things a lot cleaner to use.

Ok.

