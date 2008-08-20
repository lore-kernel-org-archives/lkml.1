Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYHTKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYHTKwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYHTKwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:52:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:47602 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbYHTKwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:52:23 -0400
Date: Wed, 20 Aug 2008 20:51:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, chrisw@sous-sol.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] security: add/fix security kernel-doc
In-Reply-To: <20080817214422.3d7b6c8a.randy.dunlap@oracle.com>
Message-ID: <alpine.LRH.1.10.0808202051130.3481@tundra.namei.org>
References: <20080817214422.3d7b6c8a.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add security/inode.c functions to the kernel-api docbook.
> Use '%' on constants in kernel-doc notation.
> Fix several typos/spellos in security function descriptions.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
