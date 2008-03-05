Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbYCEBjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbYCEBjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYCEBiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:38:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44579 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYCEBiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:38:51 -0500
Date: Wed, 05 Mar 2008 10:38:19 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [patch 03/21] use an array for the LRU pagevecs
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org
In-Reply-To: <20080304153800.4cadcc93@cuia.boston.redhat.com>
References: <20080304200209.1EAB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080304153800.4cadcc93@cuia.boston.redhat.com>
Message-Id: <20080305103754.1EBA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > this is fixed patch of Andy Whitcroft's point out.
> > (at least, I hope it)
> 
> Applied, except for the documentation to ____pagevec_lru_add, since
> that function should, IMHO, probably stay internal to the VM and not
> be exposed in documentation.

That makes sense.
Thanks!



