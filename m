Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab0BYQhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:37:33 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:46127 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932880Ab0BYQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:37:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UreQKmYO3/yXx5y+AvX5g1t0/u3DMbvrxmbj9ej8gBqTFOt/6DsdO0lmAE0VxbAvEjoQh9g0araPFpYliwpK2uAIqDh7i+Voz3S+YfK8yDYaFK1Byr5PtxsiRnA/svp/;
Date: Thu, 25 Feb 2010 08:37:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/7] kgdboc,debug_core: Add call backs to allow kernel
 mode switching
Message-ID: <20100225083744.295cd9df@jbarnes-piketon>
In-Reply-To: <1266014188-29505-2-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
	<1266014188-29505-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 16:36:22 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> Hooks for the kgdb core for registration of the drm layer to provide a
> call backs so as to perform kernel mode switching, for use with kdb.
> 
> [jbarnes@virtuousgeek.org: add ops arg to kgdb console active &
> restore hooks]
> 
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---

You can add my s-o-b:

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
