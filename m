Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYHFGoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYHFGoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYHFGn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:43:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:64622 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbYHFGn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u+ZvoF9eFsfBvoaPVn6hijZQ8CCcimk9FKZCIxuovu/eoJuJz356oiCEePxGpcEEri
         NLzKst7a2mIOfowKDa8zk9tHzL1sBC7zxgYUtfF42D6y67jZZsyW5pUIEu4MOS1dar69
         X9L3qP81hVO+TRJ+pEHUu4eBAEgHEYoyHwpxc=
Message-ID: <b6a2187b0808052342s40a3079fq6c229e3f36faca26@mail.gmail.com>
Date: Wed, 6 Aug 2008 14:42:59 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <alpine.LFD.1.10.0808052259070.15995@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 2:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> One trivial thing to try would be to just bisect it. I assume 2.6.26 is
> fine, so while it will take a few boots to try it out (there's 8111
> commits in between, so 13 reboots should do it), the advantage of
> bisection is that it's fairly straightforward to do even if you don't have
> any clue where the problem might lurk.

Bisecting now.

Jeff.
