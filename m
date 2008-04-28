Return-Path: <linux-kernel-owner+w=401wt.eu-S1765557AbYD1DwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765557AbYD1DwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765503AbYD1Dvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:51:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46315 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765497AbYD1Dvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:51:36 -0400
Date: Sun, 27 Apr 2008 23:51:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428035133.GB14275@infradead.org>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com> <200804280148.22358.vda.linux@googlemail.com> <20080428023757.GB108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428023757.GB108924158@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that I'm happy to revisit and test patches by others if they are
useful enough.  Please add me to the CC list in that case.

