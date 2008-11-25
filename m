Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYKYEYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYKYEYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYKYEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:24:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46491 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYKYEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:24:08 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: mm: various sparse warning fix
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081125131942.26CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 13:24:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series doesn't have any functional change.
and I think it is not so serious.

However, many developer often check sparse warnings because
it is required from Documentation/SubmitChecklist.
Therefore, too many warnings can decrease development efficiency.

and, all patch independent each other.





