Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbYBTTVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbYBTTVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYBTTVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:21:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:46301 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYBTTVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sTSsdNp4FF6HjIFnBxRBR7aLKOcXSws3Zt3zzOpo4Qpap/Qx1qO3/hikauolxHERwWQX4fC4VitG8Mj8RHe7xP9YVEd7fjrwTy9uXEte+oa9yfmXqgAycxnq2wUmv6AqLEmcyfYH4GrFyc4N6bxVQbsJGOvqzehCylPN0v1CAio=
Date: Wed, 20 Feb 2008 22:21:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220192110.GD6733@cvg>
References: <20080220175145.GA6733@cvg> <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com> <20080220131442.GA18790@uranus.ravnborg.org> <11226.1203531195@redhat.com> <20080220181500.GC6733@cvg> <20080220191937.GB21139@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220191937.GB21139@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Wed, Feb 20, 2008 at 08:19:38PM +0100]
| On Wed, Feb 20, 2008 at 09:15:00PM +0300, Cyrill Gorcunov wrote:
| > [David Howells - Wed, Feb 20, 2008 at 06:13:15PM +0000]
| > | Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | 
| > | > Sam, maybe we should just eliminate this section at least for FRV?
| > | 
| > | You should have a patch in your inbox to do just that.
| > | 
| > | David
| > | 
| > 
| > Thanks David! I've got them all.
| > I think Sam will take care of them to be included in mainline.
| 
| arch stuff like this is preferably going via the arch maintainer.
| Sometimes I do all-arch patches but when they are independent
| like this one they should go via the arch maintainer.
| 
| Cyrill - I would like you to do the same cleanup for
| m32r + mn10300 + s390
| and send the patch to the respective maintainers with a cc to me.
| 
| Thanks,
| 	Sam
| 

ok, I will do it

		- Cyrill -
