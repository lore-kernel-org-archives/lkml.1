Return-Path: <linux-kernel-owner+w=401wt.eu-S1161707AbXEAK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161707AbXEAK2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161686AbXEAK2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:28:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56708 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161707AbXEAK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:28:39 -0400
Date: Tue, 1 May 2007 11:28:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       Josef Whiter <jwhiter@redhat.com>
Subject: Re: [GFS2] fix bz 231369, gfs2 will oops if you specify an invalid mount option [2/34]
Message-ID: <20070501102838.GA29429@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
	linux-kernel@vger.kernel.org, Josef Whiter <jwhiter@redhat.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com> <1178013544.5462.131.camel@quoit.chygwyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178013544.5462.131.camel@quoit.chygwyn.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Having the bugzilla ids in the subject it a bit annoying.  I understand
that cross-referencing bugs to patches is quite useful, but could
you use a special tag in the message body instead, similar to how
XFS use the SGI-PV: tag.  This also means you tell people which
bugzilla the bug actually was in.

