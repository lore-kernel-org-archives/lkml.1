Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZHYBRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZHYBRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZHYBRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:17:51 -0400
Received: from outbound-mail-30.bluehost.com ([69.89.17.212]:39713 "HELO
	outbound-mail-30.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753875AbZHYBRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:17:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jra/wB87k36mxLndIvbwgYg3zF/lnjyrWma5O00CPiRkiDrbcF2Y/9iGFtXCeUZ/2OQYuMOeZtE3kHg1GO1dIykUaT8eo4DfSMB9z26NYgnOm+lDltpR5x8BJp9YrqF8;
Date: Mon, 24 Aug 2009 18:17:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: airlied@redhat.com, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: Re: [PATCH 1/1] GPU: vgaarb, use %p in pointers prints
Message-ID: <20090824181744.37358823@jbarnes-g45>
In-Reply-To: <1250967403-30249-1-git-send-email-jirislaby@gmail.com>
References: <1250967403-30249-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 20:56:43 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> To avoid compiler warnings about different size, remove
> pointer-to-int cast and use %p directly.

Already got one like this from Dave and just applied it to my
linux-next branch. If there's anything missing, please send a followup.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
