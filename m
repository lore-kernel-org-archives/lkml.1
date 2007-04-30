Return-Path: <linux-kernel-owner+w=401wt.eu-S1031577AbXD3Ro5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031577AbXD3Ro5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031583AbXD3Ro5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:44:57 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42047 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031576AbXD3Roz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:44:55 -0400
Message-ID: <46362B14.6090106@simon.arlott.org.uk>
Date: Mon, 30 Apr 2007 18:44:52 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Revert "[POWERPC] <various>"
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few powerpc patches plus reverts in the recent push to torvalds/linux-2.6 - shouldn't this be avoided whenever possible because it could cause problems for people trying to use git bisect?

-- 
Simon Arlott
