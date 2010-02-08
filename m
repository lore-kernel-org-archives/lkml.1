Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0BHSH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0BHSH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:07:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frank Heckenbach <f.heckenbach@fh-soft.de>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: set ->group_exit_code for other CLONE_VM tasks
	too
In-Reply-To: Oleg Nesterov's message of  Sunday, 7 February 2010 18:16:15 +0100 <20100207171615.GA9854@redhat.com>
References: <20100207171615.GA9854@redhat.com>
X-Zippy-Says: Well, I'm a classic ANAL RETENTIVE!!  And I'm looking for a way to
    VICARIOUSLY experience some reason to LIVE!!
Message-Id: <20100208180621.76A611AF@magilla.sf.frob.com>
Date: Mon,  8 Feb 2010 10:06:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That seems reasonable to me.

Thanks,
Roland
