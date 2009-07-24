Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZGXI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZGXI5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZGXI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:57:35 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:36086 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZGXI5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q3K5XToWvzJEEeMRi709i0EiiTsC+Afl84h56YPA8oWLYol6qmId0gSOrzWio9aDQ7
         DFkF+ZS19ph88I/B7sPhYdHQMS7+TlQPejNEWveeJt4zdt4PtPeGxnVHwH1bOiFoR9Sm
         Zrn1EnQWkYOSHNitmD55dcaaQpNw6sVpe+B7U=
Date: Fri, 24 Jul 2009 16:59:45 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>, user-mode-linux-devel@lists.sourceforge.net,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: minor Makefile simplification through use of
	cc-ifversion
Message-ID: <20090724085945.GB6372@cr0.nay.redhat.com>
References: <200907232057.51827.elendil@planet.nl> <20090723213002.GC9488@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090723213002.GC9488@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 11:30:02PM +0200, Sam Ravnborg wrote:
>On Thu, Jul 23, 2009 at 08:57:51PM +0200, Frans Pop wrote:
>> Signed-off-by: Frans Pop <elendil@planet.nl>
>Acked-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>
>If this patch is not pisked up by anyone else I will take it in kbuild.git.

Thanks.
