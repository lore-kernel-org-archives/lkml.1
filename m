Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYBTTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYBTTTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYBTTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:19:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45705 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYBTTTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:19:30 -0500
Date: Wed, 20 Feb 2008 20:19:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
Message-ID: <20080220191937.GB21139@uranus.ravnborg.org>
References: <20080220175145.GA6733@cvg> <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com> <20080220131442.GA18790@uranus.ravnborg.org> <11226.1203531195@redhat.com> <20080220181500.GC6733@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220181500.GC6733@cvg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 09:15:00PM +0300, Cyrill Gorcunov wrote:
> [David Howells - Wed, Feb 20, 2008 at 06:13:15PM +0000]
> | Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | 
> | > Sam, maybe we should just eliminate this section at least for FRV?
> | 
> | You should have a patch in your inbox to do just that.
> | 
> | David
> | 
> 
> Thanks David! I've got them all.
> I think Sam will take care of them to be included in mainline.

arch stuff like this is preferably going via the arch maintainer.
Sometimes I do all-arch patches but when they are independent
like this one they should go via the arch maintainer.

Cyrill - I would like you to do the same cleanup for
m32r + mn10300 + s390
and send the patch to the respective maintainers with a cc to me.

Thanks,
	Sam
