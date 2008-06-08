Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYFHUKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYFHUKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYFHUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:10:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbYFHUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:10:18 -0400
Date: Sun, 8 Jun 2008 13:10:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@jp.fujitsu.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] introduce sysctl of throttle
Message-Id: <20080608131013.b178084b.akpm@linux-foundation.org>
In-Reply-To: <20080605021505.694195095@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com>
	<20080605021505.694195095@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 11:12:16 +0900 kosaki.motohiro@jp.fujitsu.com wrote:

>  # echo 5 > /proc/sys/vm/max_nr_task_per_zone

Please document /proc/sys/vm tunables in Documentation/filesystems/proc.txt
