Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYJBHBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYJBHBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 03:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJBHBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 03:01:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37429 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYJBHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 03:01:29 -0400
Date: Thu, 2 Oct 2008 16:06:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] buddy: explicitly identify buddy field use in
 struct page
Message-Id: <20081002160617.03dcfba7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1222864261-22570-4-git-send-email-apw@shadowen.org>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org>
	<1222864261-22570-4-git-send-email-apw@shadowen.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Oct 2008 13:31:00 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> Explicitly define the struct page fields which buddy uses when it owns
> pages.  Defines a new anonymous struct to allow additional fields to
> be defined in a later patch.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

