Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYKASXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYKASXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYKASXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:23:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYKASXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:23:09 -0400
Date: Sat, 1 Nov 2008 18:23:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [PATCH] missing dependencies on HAS_CLK in drivers/mfd
Message-ID: <20081101182308.GZ28946@ZenIV.linux.org.uk>
References: <E1KwL4p-0000TA-Ef@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KwL4p-0000TA-Ef@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... HAVE_CLK, even.  Sorry, screwed subject line - the patch itself
is correct.
