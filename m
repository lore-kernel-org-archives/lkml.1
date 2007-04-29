Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXD2Iz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXD2Iz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXD2Iz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:55:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50765 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755087AbXD2Iyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:54:44 -0400
Date: Sun, 29 Apr 2007 01:54:43 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: bad_page from quicklist patches
Message-Id: <20070429015443.c1e31844.pj@sgi.com>
In-Reply-To: <20070429012202.b0c11d4f.akpm@linux-foundation.org>
References: <20070429081610.5469.36016.sendpatchset@v0>
	<20070429012202.b0c11d4f.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> That should have been fixed in -mm2

Verified.  2.6.21-rc7-mm2 builds and boots on my SN2 (ia64).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
