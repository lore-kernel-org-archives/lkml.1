Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZBSU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZBSU5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZBSU53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:57:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbZBSU53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:57:29 -0500
Date: Thu, 19 Feb 2009 21:53:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, roland@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][v8] Container-init signal semantics
Message-ID: <20090219205355.GC374@redhat.com>
References: <20090219030207.GA18783@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090219030207.GA18783@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18, Sukadev Bhattiprolu wrote:
>
> Patch 5/7 is new in this set and fixes a bug.

To clarify, the current code is buggy, and the fix doesn't depend on
any other patch, afaics.

> Remaining patches are
> just a forward-port from previous version and I believe they address
> all comments I have received.
>
> Oleg please sign-off/ack if you agree.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

