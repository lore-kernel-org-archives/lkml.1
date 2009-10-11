Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZJKOUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZJKOUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZJKOUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:20:34 -0400
Received: from tneu02.synserver.de ([217.119.58.222]:3711 "EHLO
	tneu02.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZJKOUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:20:34 -0400
From: Thomas Neumann <tneumann@users.sourceforge.net>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: deadlock with fallocate
Date: Sun, 11 Oct 2009 16:19:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.28-15-generic; KDE/4.2.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com
References: <hah08m$p1a$1@ger.gmane.org> <200910111053.57159.tneumann@users.sourceforge.net> <20091011121752.GA3202@lst.de>
In-Reply-To: <20091011121752.GA3202@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910111619.51664.tneumann@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. Oktober 2009 14:17:52 schrieb Christoph Hellwig:
> Thomas, I'll look at this ASAP.  It's been a bit of a busy time, just
> returning from a conference.  Any sort of self-contained testcase would
> be perfect, though.
I will send you a mail with a pointer to test data and code tomorrow. It is 
"self-contained" in the sense that it has no external dependencies, but it is 
somewhat large...

Thomas

