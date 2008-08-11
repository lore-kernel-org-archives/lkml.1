Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYHKKBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYHKKBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYHKKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:01:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39599 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYHKKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:01:26 -0400
Subject: Changing the timing of -gitX snapshot releases?
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080210125432.GA21729@mit.edu>
References: <20080209093933.GA5882@lst.de> <20080210065222.GA22951@lst.de>
	 <20080210125432.GA21729@mit.edu>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 11:01:14 +0100
Message-Id: <1218448874.12956.9.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-10 at 07:54 -0500, Theodore Tso wrote:
> <aside> it would be nice if that happend at
> 3am Pacific instead of midnight Pacific since very occasionally it's a
> little after midnight before Linus pushes his last set of changes to
> master.kernel.org</aside>

That can be done. Does anyone else really care about the timing of the
snapshots? TBH I've no idea how I ended up with '7,19' in my crontab...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



