Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZBTSbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZBTSbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZBTSbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:31:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbZBTSbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:31:42 -0500
Date: Fri, 20 Feb 2009 10:30:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jan Kara <jack@suse.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: mmotm 2009-02-10-16-35 uploaded (reiser4-quota)
Message-Id: <20090220103054.ca7cf74c.akpm@linux-foundation.org>
In-Reply-To: <499EF28F.4080508@acm.org>
References: <499305AD.4020900@oracle.com>
	<20090211171324.GC13817@duck.suse.cz>
	<20090212114737.C8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090211185321.138bb93a.akpm@linux-foundation.org>
	<499EF28F.4080508@acm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 11:12:31 -0700 Zan Lynx <zlynx@acm.org> wrote:

> Are there going to be any more -mm releases or are we supposed to use 
> mmotm only now?

The need for them is less now, because 95% of what was in -mm's is now
in linux-next.  A few people are testing -mmotm.

The main thing that's missing is that doing a release forced me to test
it all on a bunch of machines and I've got a bit slack in that regard
now.

I should get off my butt and feed mmotm into linux-next, really.  It's
a bit tricky, but I did work out a scheme a while back...
