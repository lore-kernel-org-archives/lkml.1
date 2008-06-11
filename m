Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYFKOI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYFKOI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYFKOIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:08:48 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3951 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYFKOIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:08:47 -0400
Date: Wed, 11 Jun 2008 09:43:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080611134323.GA7149@tuxdriver.com>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com> <20080609001540.GA19072@ime.usp.br> <20080611093605.GA13557@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080611093605.GA13557@ime.usp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 06:36:05AM -0300, Rogério Brito wrote:
> Hi, Ivo and John.
> 
> I don't know if you received my earlier message.
> 
> On Jun 08 2008, Rogério Brito wrote:
> > Correction here: I just went to the ia32 notebook again and, now, running
> > Ubuntu's hardy kernel (which is a patched 2.6.24 kernel, AFAIK---yes, it
> > is; just checked it) I could make the D-Link stick work fine.
> 
> The only problem that I had is that I had to reissue the command "iwconfig
> wlan0 ap any" or, otherwise, the connection with the AP would be dropped (I
> can get a log for you to peruse, if you wish).

What does "iwconfig wlan0" show _before_ doing the "iwconfig wlan0 ap any"?

John
-- 
John W. Linville
linville@tuxdriver.com
