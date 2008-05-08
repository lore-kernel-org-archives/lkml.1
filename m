Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYEHAIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYEHAIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYEHAIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:08:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36595 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYEHAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:08:22 -0400
Date: Thu, 08 May 2008 09:08:00 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mm/page_alloc.c: fix a typo
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0805061050110.23336@schroedinger.engr.sgi.com>
References: <482029E7.6070308@cn.fujitsu.com> <Pine.LNX.4.64.0805061050110.23336@schroedinger.engr.sgi.com>
Message-Id: <20080508090647.4A7B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Sorry for the noise, but the signed-off was eaten. :(
> > Maybe I should leave a blank line before the signed-off.
> 
> I think the | there was some developers attempt to avoid gcc generating 
> too many branches. I am fine either way.

Agreed.
but it is not normal conding style.
comment adding is better, IMHO.

at first, I think typo too.


