Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYGQJYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYGQJYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYGQJYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:24:17 -0400
Received: from namei.org ([69.55.235.186]:36447 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752143AbYGQJYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:24:17 -0400
Date: Thu, 17 Jul 2008 19:23:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] do_wait: return security_task_wait() error code in
 place of -ECHILD
In-Reply-To: <20080717071356.A5A2C15411D@magilla.localdomain>
Message-ID: <Xine.LNX.4.64.0807171922570.1345@us.intercode.com.au>
References: <20080717071141.012BD15411D@magilla.localdomain>
 <20080717071356.A5A2C15411D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Roland McGrath wrote:

> Signed-off-by: Roland McGrath <roland@redhat.com>

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
