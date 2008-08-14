Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbYHNWJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbYHNWJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYHNWJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:09:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYHNWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:09:16 -0400
Subject: Re: Would it be better for git-commits-head to have -M -C diffs?
From: David Woodhouse <dwmw2@infradead.org>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
References: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 23:09:10 +0100
Message-Id: <1218751750.3184.18.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:56 -0400, James Cloos wrote:
> Would anyone else prefer to see the posts on the commits list use git's
> copy and move detection?
> 
> Git show (used by the feed-mail-list script) does support -M and -C.

I see no particular reason not to do that. I've spent the whole day
screwing with magic git scripts on master.kernel.org, fixing the
headers-export stuff; I'll do that when I'm finished, if nobody screams.

> I think it would also be useful were the From: header of each message
> set to the commit's Author.  I run each commit through a script to do
> that locally, but the archives would also benefit from that.

It would be nice, but I'm not sure it's a good idea. They aren't always
valid email addresses. Maybe a Reply-To: header, rather than From: ? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



