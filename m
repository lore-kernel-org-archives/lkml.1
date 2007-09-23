Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXIWQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXIWQUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXIWQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:20:34 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:56101 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXIWQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:20:33 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 3/3] cxacru: Cleanup code by removing "ret = ret;" assignments
Date: Sun, 23 Sep 2007 18:20:32 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <46F68708.6070409@simon.arlott.org.uk> <46F687E8.3010101@simon.arlott.org.uk>
In-Reply-To: <46F687E8.3010101@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231820.33086.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007 17:36:08 Simon Arlott wrote:
> Cleanup code by removing "ret = ret;" assignments.
> 
> Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>

Acked-by: Duncan Sands <baldrick@free.fr>
