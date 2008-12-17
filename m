Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757617AbYLQDRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbYLQDRb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYLQDRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:17:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYLQDRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:17:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@tv-sign.ru>, bastian@waldi.eu.org,
        Pavel Emelyanov <xemul@openvz.org>,
        Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] Fix si_pid value in mqueue do_notify()
In-Reply-To: Sukadev Bhattiprolu's message of  Friday, 12 December 2008 18:39:15 -0800 <20081213023915.GA4256@us.ibm.com>
References: <20081213023915.GA4256@us.ibm.com>
X-Shopping-List: (1) Obsolescent virulent deception preserves
   (2) Imported champions
   (3) Asynchronous confrontation friction
Message-Id: <20081217031549.02D10FC3BC@magilla.sf.frob.com>
Date: Tue, 16 Dec 2008 19:15:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By: Roland McGrath <roland@redhat.com>
