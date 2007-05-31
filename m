Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbXEaWJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbXEaWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 18:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXEaWJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 18:09:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46557 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbXEaWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 18:09:48 -0400
Date: Thu, 31 May 2007 15:08:57 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/3] syslet demos - add more includes
Message-ID: <20070531220857.GM5488@mami.zabbo.net>
References: <20070531180429.GA9782@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531180429.GA9782@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a bunch of includes to sys.h and syslet.h to kill off compilation warnings.

This, and the patches which add tests, all look great to me.

Ingo, are you patching up your tests or do you want me to take care of
these?

- z
