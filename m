Return-Path: <linux-kernel-owner+w=401wt.eu-S935286AbYBCAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbYBCAQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764875AbYBCAQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:16:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764799AbYBCAQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:16:26 -0500
Date: Sat, 2 Feb 2008 16:16:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [MEMSTICK] Updates for the memstick driver
Message-Id: <20080202161635.fc02de0c.akpm@linux-foundation.org>
In-Reply-To: <439089.5370.qm@web36701.mail.mud.yahoo.com>
References: <20080122105900.c7ea1cc3.akpm@linux-foundation.org>
	<439089.5370.qm@web36701.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes to the block core in mainline have destroyed this driver.  This was
hitherto not known because I was unable to carry git-block in -mm
because it blithely tromped all over other people's code.  

I'll disable the memstick driver in config for now.  Please send fixes?
