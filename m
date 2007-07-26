Return-Path: <linux-kernel-owner+w=401wt.eu-S934597AbXGZRAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597AbXGZRAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763958AbXGZQ7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:59:52 -0400
Received: from smtp103.plus.mail.re1.yahoo.com ([69.147.102.66]:39587 "HELO
	smtp103.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756960AbXGZQ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:59:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=SediLcaJqpwpMC2Mt4xvGu5PsRo2yf9dkeEOXWIv5CBZc7pAAQth09S2vRFXwJvqRgSO3ottT5u5gVfvtg8F5aRW3JIy8vWSGfS0dn29o6rZKaa9k3mphp0gy3gfn24ZDAmS05BiLPe1mLTFn9vwdNZSqVlqCZnJ/lB4G1J9htI=  ;
X-YMail-OSG: 2SwNPmAVM1naJxf2oOxEp18XiMRBzAkyBJkJA4uOFj_9ZY_RrNlq9jMiy1q_U7V7QhWqHxU0wg--
Date: Thu, 26 Jul 2007 18:59:06 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Xudong Guan <xudong.guan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726165906.GB4570@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <20070726163618.GA13789@xguan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070726163618.GA13789@xguan-laptop>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 05:36:18PM +0100, Xudong Guan wrote:
> On 18:30(+0200) Thu 26 Jul, Borislav Petkov wrote:
> > grub version:
> > Version: 0.97-29
> 
> On my real machine with grub 0.97, there is no problem loading the
> same kernel.

Do you mean the kernel with the 4fd06960f120e02e9abc802a09f9511c400042a5 commit
on top?

-- 
Regards/Gruﬂ,
    Boris.
