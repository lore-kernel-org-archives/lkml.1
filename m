Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXJaTRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXJaTRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXJaTR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:17:26 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:60597 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXJaTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:17:25 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: 2.4.24-rc1-git: crash on shutdown/unmount?
Date: Wed, 31 Oct 2007 19:17:21 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311917.21441.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I guessed from the oops that you might have an idea what's causing this oops 
on shutdown/unmount. The git version (describe), a screenshot showing the 
oops, a config, and dmesg for a booted kernel are available from:

http://devzero.co.uk/~alistair/oops-20071031/

I went back to -rc1 and it still happens there too. If you need any more 
information or want me to bisect it, please let me know.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
