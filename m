Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZDMTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZDMTG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZDMTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:06:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbZDMTGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:06:45 -0400
Message-ID: <49E38D41.6030004@garzik.org>
Date: Mon, 13 Apr 2009 15:06:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] microblaze: Fix problem with removing zero length
 files
References: <1239649017-5850-1-git-send-email-monstr@monstr.eu>
In-Reply-To: <1239649017-5850-1-git-send-email-monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Adding one new line was recommended solution.
> Test with make distclean
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Tested-by: Jeff Garzik <jgarzik@redhat.com>

Thanks!


