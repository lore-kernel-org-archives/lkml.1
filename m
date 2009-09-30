Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbZI3APn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbZI3APn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZI3APn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:15:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbZI3APl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:15:41 -0400
Date: Tue, 29 Sep 2009 17:15:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       yehuda@newdream.net, sage@newdream.net
Subject: Re: [PATCH 06/21] ceph: inode operations
Message-Id: <20090929171511.29836c82.akpm@linux-foundation.org>
In-Reply-To: <1253641129-28434-7-git-send-email-sage@newdream.net>
References: <1253641129-28434-1-git-send-email-sage@newdream.net>
	<1253641129-28434-2-git-send-email-sage@newdream.net>
	<1253641129-28434-3-git-send-email-sage@newdream.net>
	<1253641129-28434-4-git-send-email-sage@newdream.net>
	<1253641129-28434-5-git-send-email-sage@newdream.net>
	<1253641129-28434-6-git-send-email-sage@newdream.net>
	<1253641129-28434-7-git-send-email-sage@newdream.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 10:38:34 -0700
Sage Weil <sage@newdream.net> wrote:

> Inode cache and inode operations.

Attention span expired.  Please take previous comments and apply them
to all the other patches ;)

The code looks reasonable to me.  Unless others emit convincing
squeaks, please ask Stephen to include your git tree into linux-next
sometime within the next month, then send Linus a pull request for
2.6.33.
