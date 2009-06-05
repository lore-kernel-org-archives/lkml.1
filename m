Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZFEEuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZFEEuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZFEEtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:49:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39209 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZFEEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:49:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] - support inheritance of mlocks across fork/exec V2
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       hugh@veritas.com
In-Reply-To: <1244176757.11597.24.camel@localhost.localdomain>
References: <1228331069.6693.73.camel@lts-notebook> <1244176757.11597.24.camel@localhost.localdomain>
Message-Id: <20090605134641.FC25.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  5 Jun 2009 13:49:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2008-12-03 at 14:04 -0500, Lee Schermerhorn wrote:
> 
> > Add support for mlockall(MCL_INHERIT|MCL_RECURSIVE):
> 
> FWIW, I really liked this patch series. And I think there is still value
> in a generic "mlock" wrapper utility that I can use. Sure, the later on
> containers suggestions are all wonderful in theory but I don't see that
> that went anywhere either (and I disagree that we can't trust people to
> use this right without doing silly things) - if I'm really right that
> this got dropped on the floor, can we resurrect it in .31 please?

I guess Lee is really really busy now.
Can you make V3 patch instead?




