Return-Path: <linux-kernel-owner+w=401wt.eu-S935340AbYD1RaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340AbYD1RaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbYD1R3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:29:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46883 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933102AbYD1R3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:29:47 -0400
Date: Mon, 28 Apr 2008 12:29:45 -0500
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, bert.wesarg@googlemail.com, mingo@elte.hu,
       travis@sgi.com, mm-commits@vger.kernel.org
Subject: Re: - bitmap-fix-calculation-of-bitmap_scnprintf_len.patch removed
 from -mm tree
Message-Id: <20080428122945.2566772a.pj@sgi.com>
In-Reply-To: <200804281721.m3SHL1q0005859@imap1.linux-foundation.org>
References: <200804281721.m3SHL1q0005859@imap1.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch was dropped because of confusion

Heck ... if that was a valid reason, then alot more patches would
get dropped <grin>.

Looks like Mike will push a patch to just remove these unused
routines, so as usual, you're doing the right thing here, Andrew.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
