Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYG1WC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYG1WC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYG1WCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:02:21 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:47279 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750819AbYG1WCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:02:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=AhnrA0s9zXCql18JFQzP5EGQSQS6NeGixi39iJH7hx1mFm545mLVplo77IJHgPd2VC4U7Gs2sCbZJ9G5E6aEYC85lzu/+Kz5gwXol/UsARbzYIY43hgy56hcXdBrthS8;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] generic coherent dma
Date: Mon, 28 Jul 2008 15:02:11 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
References: <20080720105822.GA4075@doriath.ww600.siemens.net> <20080720192558.GA6576@elte.hu>
In-Reply-To: <20080720192558.GA6576@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281502.11427.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 20, 2008 12:25 pm Ingo Molnar wrote:
> * Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > Hi,
> >
> > These two patches probably are the last for the tip
> > core/generic-dma-coherent branch. The first one converts cris arch to
> > use the generic allocator. The second one adds documentation for new
> > interfaces. So, I think, the branch is ready to be scheduled for the
> > merge (or at least testing in the linux-next).
>
> applied to tip/core/generic-dma-coherent.
>
> Jesse, please pull it into pci.git - the x86 bits are well-tested and
> stable. See the pull coordinates below.
>
> 	Ingo
>
> ---------------------------------->
> Please pull the latest core/generic-dma-coherent git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> core/generic-dma-coherent

Just tried pulling this; I get conflicts in arch/x86/Kconfig.  Is your branch 
not up to date?

Thanks,
Jesse
