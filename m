Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbZD1Gwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbZD1Gwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbZD1Gwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:52:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48350 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZD1Gwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:52:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Elladan <elladan@eskimo.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090428063625.GA17785@eskimo.com>
References: <20090428143019.EBBF.A69D9226@jp.fujitsu.com> <20090428063625.GA17785@eskimo.com>
Message-Id: <20090428154835.EBC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 15:52:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 3. cache limitation of memcgroup solve this problem?
> 
> I was unable to get this to work -- do you have some documentation handy?

Do you have kernel source tarball?
Documentation/cgroups/memory.txt explain usage kindly.




