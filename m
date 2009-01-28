Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZA1EMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZA1EMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA1EMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:12:22 -0500
Received: from tundra.namei.org ([65.99.196.166]:3695 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZA1EMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:12:21 -0500
Date: Wed, 28 Jan 2009 15:11:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LKLM <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] smackfs load append mode fix - resend unmundged.
In-Reply-To: <497FD9CD.1090202@schaufler-ca.com>
Message-ID: <alpine.LRH.1.10.0901281510260.14028@tundra.namei.org>
References: <497FD9CD.1090202@schaufler-ca.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Casey Schaufler wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Given just how hard it is to find the code that uses MAY_APPEND
> it's probably not a big surprise that this went unnoticed for so
> long. The Smack rules loading code is incorrectly setting the
> MAY_READ bit when MAY_APPEND is requested.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
