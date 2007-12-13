Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXLMSZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXLMSZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXLMSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:24:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35771 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXLMSYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:24:55 -0500
Date: Thu, 13 Dec 2007 19:26:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: Re: separate objdir Makefile regression in 2.6.24-rc*
Message-ID: <20071213182645.GB12134@uranus.ravnborg.org>
References: <20071213134841.GA25103@basil.nowhere.org> <3d8471ca0712130616w4a34b53bs2faafb159df17510@mail.gmail.com> <20071213143359.GA31269@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213143359.GA31269@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 03:33:59PM +0100, Andi Kleen wrote:
> On Thu, Dec 13, 2007 at 03:16:27PM +0100, Guillaume Chazarain wrote:
> > On Dec 13, 2007 2:48 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > > 2.6.24-rc5 doesn't seem to create Makefiles in empty obj dirs anymore
> > 
> > Known problem ;-)
> > See http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/188cbd12d7c0871b/194fbc7c94314b2c
> 
> Ah, thanks. But it looks like that patch isn't in Linus' tree yet. Sam? 

I have asked Linus to pull it.

	Sam
