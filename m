Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYDZJgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYDZJgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYDZJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:36:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:30878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYDZJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=OaNTD/ZeInSqutZHJBqQXe5ztZDS+vjIbTTb54J32cHNm4VkyDdvYLUCJl16LU3LSCD9l7vRj1hjPefTxmzpT1IWlsUKUgddFOrWDMYcfwgdeVza0YihiOQeNZrYHhBFOjdY7zkRZbRLlXko7h200t8idE9VcAgI+xFm76CgD1A=
Date: Sat, 26 Apr 2008 17:35:38 +0800 (CST)
Message-Id: <20080426.173538.195417245.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 9/19] UML - Tidy ptrace interface
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080425175610.GA11188@c2.user-mode-linux.org>
References: <20080425175610.GA11188@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Date: Fri, 25 Apr 2008 13:56:10 -0400
> Tidy the ptrace interface code.  Removed a bunch of unused macros.
> Started converting register sets from arrays of longs to structures.

Could you please explain a bit why do this? I think long arrary is OK.

Thanks.

Cong
