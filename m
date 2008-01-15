Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYAOJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYAOJEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYAOJEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:04:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43627 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYAOJEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:04:31 -0500
Date: Tue, 15 Jan 2008 18:03:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] mmaped copy too slow?
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1200387478.15103.21.camel@twins>
References: <20080115115318.1191.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1200387478.15103.21.camel@twins>
Message-Id: <20080115180130.119A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> > > While being able to deal with used-once mappings in page reclaim
> > > could be a good idea, this would require us to be able to determine
> > > the difference between a page that was accessed once since it was
> > > faulted in and a page that got accessed several times.
> > 
> > it makes sense that read ahead hit assume used-once mapping, may be.
> > I will try it.
> 
> I once had a patch that made read-ahead give feedback into page reclaim,
> but people didn't like it.

Could you please tell me your mail subject or URL?
I hope know why people didn't like.

thanks

- kosaki



