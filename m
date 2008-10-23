Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYJWRw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYJWRw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYJWRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:52:51 -0400
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:53449 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752457AbYJWRwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:52:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uHZ96eS2RH3jtYlwOR08w1CDwBt4C7vhxvN3+Fu9hMm5xU1i82h/Hgmyneq9L+zRlSkNeYRl7W3Pz0TN6nHtHzOkjV5VMrcBFnnwjf609gzL2b4WKeNk2rFCxiOZcqAX;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] PCI pull request #2 for 2.6.28
Date: Thu, 23 Oct 2008 10:52:47 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <200810221714.18723.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0810231043560.3287@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810231043560.3287@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810231052.47621.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2008 10:46 am Linus Torvalds wrote:
> On Wed, 22 Oct 2008, Jesse Barnes wrote:
> > A few more bits for 2.6.28, mainly hotplug related stuff so the risk
> > should be pretty low.  There are a few good fixes in here though too: a
> > build fix for some architectures due to the new ioremap_nocache usage in
> > pci.h and a fix for a refcounting bug.
>
> Pulled.
>
> Ingo tells me that the ARI code is broken on his Nehalem, and that there's
> already a confirmed fix for it by Yu Zhao ("[PATCH] pci: fix ARI") but
> it's not in this series.
>
> Hmm? Status?

Yeah came in after I set up my pull request; I'll queue it up today.

-- 
Jesse Barnes, Intel Open Source Technology Center

