Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXH1ULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXH1ULX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbXH1ULI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:11:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:18592 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbXH1ULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:11:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MKxuIuuOWVN00xzP6LbY17NJ5PCsdFdLFOXcLUZ3EILSBDsJta3aw2/5lpDanISdAgtT3UEO17O2mbmr6QomgeGcPzTpbNfYcl/qkZ9LyMK+YF5jE1/Xi0ZRkknosM7u6SqCSF2j3fbBo+jaNLYveV2bM8yV2Hw6mhe1SyNmRQE=
Message-ID: <43e72e890708281311y630b85fcjb132bd065478d760@mail.gmail.com>
Date: Tue, 28 Aug 2007 16:11:03 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
In-Reply-To: <20070828171155.GC29343@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <7515194658758617@pripojeni.net>
	 <20070828171155.GC29343@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Aug 28, 2007 at 12:00:50PM -0400, Jiri Slaby wrote:
> > ath5k, license is GPLv2
> >
> > The files are available only under GPLv2 since now.
>
> Is this really a good idea?  Most of the reverse-engineering was
> done by the OpenBSD folks, and it would certainly be helpful to
> work together with them on new hardware revisions, etc..

Technically the best we can do is to leave the license as dual
licensed, but keep in that technically that means nothing and is just
for show, the GPL is what would apply as its derivative work and is
the most restrictive license. This applies to any other driver in the
kernel right now with a dual license tag.

  Luis
