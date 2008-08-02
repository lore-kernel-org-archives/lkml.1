Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbYHBF5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbYHBF5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 01:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYHBF5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 01:57:36 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:16766 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYHBF5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 01:57:36 -0400
Date: Sat, 2 Aug 2008 07:58:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, Yudha Harimantoro T <yudha.ht@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Avuton Olrich <avuton@gmail.com>
Subject: Re: Error on Make Modules [2.6.27-rc1]
Message-ID: <20080802055803.GA16765@uranus.ravnborg.org>
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com> <20080801224153.GL19682@cs181140183.pp.htv.fi> <1217631100.3719.44.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217631100.3719.44.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Fri, Aug 01, 2008 at 11:51:40PM +0100, David Woodhouse wrote:
> On Sat, 2008-08-02 at 01:41 +0300, Adrian Bunk wrote:
> > Can you somehow hide this message?
> 
> I'll leave the __fw_install one alone, so that if there's nothing to do
> for 'make firmware_install' it says so rather than just doing nothing.
> The other two can shut up, as requested.

I assume you push this one to Linus - right?

	Sam
