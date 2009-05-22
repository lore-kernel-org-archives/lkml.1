Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZEVCma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZEVCma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 22:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZEVCmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 22:42:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:57120 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZEVCmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 22:42:22 -0400
Date: Fri, 22 May 2009 12:42:12 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Roel Kluin <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] smack:beyond ARRAY_SIZE of data
In-Reply-To: <4A160E28.1010306@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.0905221235530.7391@tundra.namei.org>
References: <4A141F83.10102@gmail.com> <4A1483E0.1030303@schaufler-ca.com> <4A15848E.5030403@gmail.com> <4A160E28.1010306@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Casey Schaufler wrote:

> Roel Kluin wrote:
> > Do not go beyond ARRAY_SIZE of data
> >
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> >   
> 
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Thank you. The fix is appreciated.
> 

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

(This needs CAP_MAC_ADMIN to trigger, so I'll assume this is not 
security-critical, but yell if you disagree).


- James
-- 
James Morris
<jmorris@namei.org>
