Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZAFWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZAFWEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZAFWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:04:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39738
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZAFWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:04:44 -0500
Date: Tue, 06 Jan 2009 14:04:46 -0800 (PST)
Message-Id: <20090106.140446.94442493.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/23] sparc: introduce asm/swab.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1231277450.964.266.camel@brick>
References: <1231277450.964.266.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 06 Jan 2009 13:30:50 -0800

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: David S. Miller <davem@davemloft.net>


> Dave, I would have rather moved the SWAB_64_THRU_32 bit to the
> top of swab.h like all other arches, but I kept it a pure movement patch.
> 
> It seems to make sense for sparc the way it is however, just FYI.

Ok.
