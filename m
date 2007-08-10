Return-Path: <linux-kernel-owner+w=401wt.eu-S941308AbXHJQe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941308AbXHJQe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765174AbXHJQeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:34:17 -0400
Received: from [209.59.210.129] ([209.59.210.129]:58799 "EHLO
	sydney.geekteck.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765109AbXHJQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:34:16 -0400
From: pointman@sydney.geekteck.com
Message-Id: <200708101600.l7AG0EfW009573@sydney.geekteck.com>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
To: linux-kernel@vger.kernel.org
Date: Fri, 10 Aug 2007 11:00:14 -0500 (CDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the manual page mount(8) with an expanded description of atime/noatime and adding nodirtime and data=<option> seems much more reasonable than hacking the kernel because you want others to run their systems the way you think they should.

Almost every web search of "linux fast disk" (or related words) references noatime, and many ext3 specific documents explain the caching options.
