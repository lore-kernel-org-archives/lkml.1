Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0BWUXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:23:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0BWUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:23:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ia64: ptrace: kill thread_matches()
In-Reply-To: Oleg Nesterov's message of  Tuesday, 23 February 2010 19:16:32 +0100 <20100223181632.GA19586@redhat.com>
References: <20100223181632.GA19586@redhat.com>
X-Shopping-List: (1) Melodramatic emotions
   (2) Lingering vapor
   (3) Sagacious compressors
   (4) Interlocking yies
Message-Id: <20100223202302.68E8D64C@magilla.sf.frob.com>
Date: Tue, 23 Feb 2010 12:23:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

ia64 folks, please excise the cruft so that it does not hold us back
in making later arch-neutral ptrace changes.


Thanks,
Roland
