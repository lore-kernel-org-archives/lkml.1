Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYJ0NDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYJ0NDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYJ0NDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:03:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYJ0NDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:03:05 -0400
Date: Mon, 27 Oct 2008 09:03:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
       "axboe@kernel.dk" <axboe@kernel.dk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add error handling of write_super_lockfs/unlockfs
Message-ID: <20081027130259.GA1919@infradead.org>
References: <20081027215832t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027215832t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.
