Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZFFHZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZFFHZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZFFHZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:25:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZFFHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:25:10 -0400
Subject: Re: [PATCH v2.1 10/17] JFFS2: do not manipulate s_dirt directly
From: David Woodhouse <dwmw2@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-mtd@lists.infradead.org
In-Reply-To: <1244207155-2092-11-git-send-email-dedekind@infradead.org>
References: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
	 <1244207155-2092-11-git-send-email-dedekind@infradead.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 08:25:08 +0100
Message-Id: <1244273108.3751.1029.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 16:05 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> ... use new VFS helpers instead.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org

Presumably this is intended for Al's tree rather than mine? I could
massage it and apply it here, but then someone would just have to
massage it back when they eventually get merged.

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

