Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYHDAiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYHDAiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 20:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYHDAiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 20:38:17 -0400
Received: from namei.org ([69.55.235.186]:56521 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751904AbYHDAiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 20:38:17 -0400
Date: Mon, 4 Aug 2008 10:37:28 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Peter.Wahl@oracle.com
Subject: Re: [PATCH] smack: limit privilege by label
In-Reply-To: <4890ED17.6050305@schaufler-ca.com>
Message-ID: <Xine.LNX.4.64.0808041035410.18295@us.intercode.com.au>
References: <4890ED17.6050305@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Casey Schaufler wrote:

> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Reviewed-by: James Morris <jmorris@namei.org>


I also added this to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git#next 
and #devel.

Holler if you don't want it to go to linux-next this way.


- James
-- 
James Morris
<jmorris@namei.org>
