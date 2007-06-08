Return-Path: <linux-kernel-owner+w=401wt.eu-S970856AbXFHQrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970856AbXFHQrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966808AbXFHQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:47:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37675 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762861AbXFHQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:47:14 -0400
In-Reply-To: <20070608163302.GA9101@c2.user-mode-linux.org>
References: <20070531181923.GA9904@c2.user-mode-linux.org> <20070607232733.GM17082@mami.zabbo.net> <20070608161048.GA8147@c2.user-mode-linux.org> <CBFDCBBC-B5D8-4A91-9322-D63E107F38BF@oracle.com> <20070608163302.GA9101@c2.user-mode-linux.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <46AA734B-D157-4F9C-B238-E43031666C88@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Chris Mason <chris.mason@oracle.com>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Date: Fri, 8 Jun 2007 09:46:55 -0700
To: Jeff Dike <jdike@addtoit.com>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The latter - it fails the test that I posted.

OK, good.  That's easy enough to fix :)  I'll send out a tested version.

- z
