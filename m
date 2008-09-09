Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYIIS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYIIS1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbYIIS1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:27:12 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:51185 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbYIIS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:27:11 -0400
Date: Tue, 9 Sep 2008 14:27:10 -0400
To: Jarod Wilson <jwilson@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Janne Grunau <j@jannau.net>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>,
       Eric Sandeen <esandeen@redhat.com>,
       Mario Limonciello <superm1@ubuntu.com>
Subject: Re: [PATCH 0/18] linux infrared remote control drivers
Message-ID: <20080909182710.GA31271@csclub.uwaterloo.ca>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080909124608.GA27837@infradead.org> <200809091123.57109.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809091123.57109.jwilson@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 11:23:56AM -0400, Jarod Wilson wrote:
> I meant to include that the ordering of the patches was more or less from 
> most-used/most-tested to least-used/least-tested, and a few of the patches do 
> include Tested-by: lines in them. Basically, the first four or five drivers 
> probably cover the majority of users, so getting them in first would provide 
> the most bang-for-your-buck. But I can certainly re-send with only the tested 
> drivers after we get through the first round of comments, if that's preferred 
> over my approach of putting the higher-prio ones to the front of the ordering.

The soundgraph imon driver is number 8, but it works great for me, and lots
of cases include that one (at least silverstone cases).  I think more
than the first 4 or 5 are in very active use.

-- 
Len Sorensen
