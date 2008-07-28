Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYG1WRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYG1WRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYG1WQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:16:54 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:41797 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751323AbYG1WQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:16:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=K7kKq2kEbhz6iDX1a6T4SJaIdwpwHvEaHJw3xMMKx5BRPMi/R/lR51e/dNnQrURyQ3+amkvfbtU5xVEHhqNn8s8N3qSRIeMh9vsv6FSiJHgx5sK0b/IKq6rWzlHTtNAx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] generic coherent dma
Date: Mon, 28 Jul 2008 15:16:46 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
References: <20080720105822.GA4075@doriath.ww600.siemens.net> <200807281502.11427.jbarnes@virtuousgeek.org> <20080728220929.GA9845@elte.hu>
In-Reply-To: <20080728220929.GA9845@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281516.47137.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > > core/generic-dma-coherent
> >
> > Just tried pulling this; I get conflicts in arch/x86/Kconfig.  Is your
> > branch not up to date?
>
> hey, you tried to pull after 8 days in the merge window - that's a few
> thousand commits down the line ;-)

Yeah sorry, this one got buried in my inbox...

> When i send pull requests the branches become generally immutable until
> they get pulled. (i.e. i dont change it under your foot)
>
> i've merged up latest -git and pushed out the result - could you retry?

Yep, got it.  Thanks.

Jesse
