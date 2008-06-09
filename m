Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYFIAeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYFIAeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYFIAeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:34:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56039 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYFIAeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:34:21 -0400
Date: Mon, 09 Jun 2008 09:34:01 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] introduce sysctl of throttle
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080608131013.b178084b.akpm@linux-foundation.org>
References: <20080605021505.694195095@jp.fujitsu.com> <20080608131013.b178084b.akpm@linux-foundation.org>
Message-Id: <20080609093319.7862.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  # echo 5 > /proc/sys/vm/max_nr_task_per_zone
> 
> Please document /proc/sys/vm tunables in Documentation/filesystems/proc.txt

Oh, makes sense.
Thank you good advice!




