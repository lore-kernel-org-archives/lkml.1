Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZGTPbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZGTPbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGTPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:31:42 -0400
Received: from smtp-out25.alice.it ([85.33.2.25]:3596 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZGTPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:31:42 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 11:31:41 EDT
Message-ID: <4A648B65.2080606@alice.it>
Date: Mon, 20 Jul 2009 17:21:09 +0200
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.22) Gecko/20090624 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.30.2: does not boot 
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2009 15:21:24.0743 (UTC) FILETIME=[BE8B9170:01CA094D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same on 2 machines,
black screen, main switch,

All values for
CONFIG_DEFAULT_MMAP_MIN_ADDR
between 0 and 655536 does not work,
recompiled for each value a kernel!

On a very similar machine it works!

Mario Vanoni
