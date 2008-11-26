Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYKZATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYKZATz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYKZATr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:19:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49054 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYKZATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:19:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] memcg reclaim shouldn't change zone->recent_rotated statics.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20081126001650.280530d0@lxorguk.ukuu.org.uk>
References: <20081126091027.3CA6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081126001650.280530d0@lxorguk.ukuu.org.uk>
Message-Id: <20081126091808.3CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 26 Nov 2008 09:19:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > however, "_p" isn't linux convention.
> > so, I like "is_" or "can_" (or likes somethingelse) prefix :)
> 
> _p is from lisp but Ted did sneak tty_hung_up_p() into the kernel many
> years ago.

Oh, you expose my knowledgeless ;-)



