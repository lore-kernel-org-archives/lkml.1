Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZGIVA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZGIVA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbZGIVAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:00:49 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58491 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753985AbZGIVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:00:49 -0400
Date: Thu, 9 Jul 2009 17:00:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/5] Show kernel stack usage to /proc/meminfo and OOM
 log
In-Reply-To: <20090709110952.2389.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907091700150.17835@gentwo.org>
References: <20090705182409.08FC.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071234070.5124@gentwo.org> <20090709110952.2389.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:

> following code in this patch mean display per-zone stack size, no?

Right.
