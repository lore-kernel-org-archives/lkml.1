Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXLQGAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXLQGAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXLQGAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:00:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:37970 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbXLQGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:00:39 -0500
Message-ID: <47661096.7020107@davidnewall.com>
Date: Mon, 17 Dec 2007 16:30:54 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
References: <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>	<47650C88.6040105@davidnewall.com>	<200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>	<476512F1.5010701@davidnewall.com>	<200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp> <200712162114.BJE04102.tOMFHOOFSJVQFL@I-love.SAKURA.ne.jp>
In-Reply-To: <200712162114.BJE04102.tOMFHOOFSJVQFL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> If Bob is malicious and creates /dev/sda1 with block-8-2 attribute [...]

Bob can't do that.  Only root can.
