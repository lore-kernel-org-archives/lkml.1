Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZLRRYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZLRRYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZLRRYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:24:06 -0500
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:41991 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753869AbZLRRYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:24:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S67/hs+qY64uqupmmqFUR5O26X7mL2h+wtEbZ0ff3dj4GFmgIMnaXj4/lnAqu8YZvtCj3MQ4QifKrB+sV45VgNeiQZ56KORDMkdNBMgbwX86zgofgcDBf68gEJiGFd9v;
Date: Fri, 18 Dec 2009 09:23:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86: check range in update range
Message-ID: <20091218092323.2a648faf@jbarnes-piketon>
In-Reply-To: <4B2B4F93.2080203@kernel.org>
References: <4B2B4C19.6010402@kernel.org>
	<4B2B4F93.2080203@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 01:46:59 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> fend off wrong range
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

This could be merged with the previous patch.

-- 
Jesse Barnes, Intel Open Source Technology Center
