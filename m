Return-Path: <linux-kernel-owner+w=401wt.eu-S936560AbYBVBdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560AbYBVBdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYBVBde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:33:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44339 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934260AbYBVBdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:33:32 -0500
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 20:33:32 EST
X-IronPort-AV: E=McAfee;i="5200,2160,5235"; a="757633"
Message-ID: <47BE266A.1080500@qualcomm.com>
Date: Thu, 21 Feb 2008 17:33:30 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: CPU isolation extensions for the stable 2.6.24.y series
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got quite a few positive responses from end-users about CPU isolation extensions that I posted awhile ago.
For people who are interested in using latest CPU isolation stuff on top of the stable 2.6.24.y tree I created 
a separate GIT tree that is available at
	git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.24.y.git

It's currently based on the 2.6.24.2 released by the stable team. I'll be pulling latest stable updates into
it as they become available.

Max
