Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYHBNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYHBNGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYHBNGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:06:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYHBNGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:06:11 -0400
Subject: Re: Error on Make Modules [2.6.27-rc1]
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Yudha Harimantoro T <yudha.ht@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Avuton Olrich <avuton@gmail.com>
In-Reply-To: <20080802055803.GA16765@uranus.ravnborg.org>
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
	 <20080801224153.GL19682@cs181140183.pp.htv.fi>
	 <1217631100.3719.44.camel@shinybook.infradead.org>
	 <20080802055803.GA16765@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 14:06:00 +0100
Message-Id: <1217682361.3719.51.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 07:58 +0200, Sam Ravnborg wrote:
> Hi David.
> 
> On Fri, Aug 01, 2008 at 11:51:40PM +0100, David Woodhouse wrote:
> > On Sat, 2008-08-02 at 01:41 +0300, Adrian Bunk wrote:
> > > Can you somehow hide this message?
> > 
> > I'll leave the __fw_install one alone, so that if there's nothing to do
> > for 'make firmware_install' it says so rather than just doing nothing.
> > The other two can shut up, as requested.
> 
> I assume you push this one to Linus - right?

I have done.

-- 
dwmw2

