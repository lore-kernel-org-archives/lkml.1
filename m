Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYC1I0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYC1I0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYC1I0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:26:44 -0400
Received: from n10.bullet.re3.yahoo.com ([68.142.237.123]:43244 "HELO
	n10.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751950AbYC1I0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:26:42 -0400
X-Yahoo-Newman-Id: 839056.45272.bm@omp203.mail.re3.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E8d2mwH2NZ7E1/hhcKHNAuWcnBhsu6SlISG54IsOtdrXOW/6b92G+KOdav9hiJ/6w6DA4meSmXju+3/XMSJu+IE2ZFNHT0ieeLy9ZAcvoEuiYXo+LrOH8mb+o73uZOZqRFEA9dGduFmd+UXBnp4i2zyT2yTXKfBKeghkhudXEa0=  ;
X-YMail-OSG: ckTQNW8VM1n0fXks9rJlR537FGzbDaZ1WxhHDKvCFKmBCFEJo5tJh.0mrr6Efl.9E6vbeUcY4w--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: down_spin() implementation
Date: Fri, 28 Mar 2008 16:03:33 +1100
User-Agent: KMail/1.9.5
Cc: Matthew Wilcox <matthew@wil.cx>, "Luck, Tony" <tony.luck@intel.com>,
       linux-arch@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <20080327141508.GL16721@parisc-linux.org> <20080328155107.e9d8866c.sfr@canb.auug.org.au>
In-Reply-To: <20080328155107.e9d8866c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281603.34134.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008 15:51, Stephen Rothwell wrote:
> Hi Willy,
>
> On Thu, 27 Mar 2008 08:15:08 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
> > Stephen, I've updated the 'semaphore' tag to point ot the same place as
> > semaphore-20080327, so please change your linux-next tree from pulling
> > semaphore-20080314 to just pulling plain 'semaphore'.  I'll use this
> > method of tagging from now on.
>
> Thanks. I read this to late for today's tree, but I will fix it up for
> the next one.

Please don't add this nasty code to semaphore.

Did my previous message to the thread get eaten by spam filters?

