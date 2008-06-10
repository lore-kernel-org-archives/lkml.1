Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYFJUB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYFJUB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYFJUBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:01:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41346 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYFJUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EmNGoU9XJRatfHjd9GHlrIxniZEtk3jnBk6Rs6wkW2Pk2U/dnGD+XMk9GYOgVUVI2V
         lJDF4FSkvQaJhNOV5FeaIOAEj1e/c81bQSkSia/UUHyhACqMRCqeaJG3WFENUyyxFe8s
         utHVOO6imNxTeDJlaAcjqlKS1/MPUwP2tO/v4=
Date: Tue, 10 Jun 2008 23:57:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hmh@hmh.eng.br
Subject: Re: Linux 2.6.25.6
Message-ID: <20080610195747.GA18926@martell.zuzino.mipt.ru>
References: <20080609194924.GL30402@sequoia.sous-sol.org> <20080610145325.GC23351@khazad-dum.debian.net> <20080610191726.GB4218@tatooine.rebelbase.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610191726.GB4218@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:17:26PM +0200, markus reichelt wrote:
> * Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> 
> > On Mon, 09 Jun 2008, Chris Wright wrote:
> > > We (the -stable team) are announcing the release of the 2.6.25.6
> > > kernel.
> > > 
> > > It contains a number of assorted bugfixes all over the tree.  Users are
> > > encouraged to update.
> > 
> > It also contains at least one security bugfix, as some were quick
> > to point out in not-so-kind words:
> > 
> > http://lwn.net/Articles/285438/
> 
> I agree that security bugfixes should be pointed out more clearly.

Person fixing a bug may not realize he fixes security-sensitive bug.
Or simply doesn't care because there are 5 more to fix for today.

