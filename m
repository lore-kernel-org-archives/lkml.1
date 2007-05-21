Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbXEUQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbXEUQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXEUQQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:16:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43820 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759863AbXEUQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:16:54 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Arjan van de Ven <arjan@infradead.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <9e4733910705210834s4b41cf31ka3f56d3bc36b5585@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <pan.2007.05.20.17.41.22@gmail.com>
	 <200705201610.32170.jbarnes@virtuousgeek.org>
	 <9e4733910705201747n1847f7b1wd57a8e8640a857a8@mail.gmail.com>
	 <4650F5F2.4000305@garzik.org>
	 <9e4733910705210834s4b41cf31ka3f56d3bc36b5585@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 21 May 2007 09:15:28 -0700
Message-Id: <1179764128.3553.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 11:34 -0400, Jon Smirl wrote:
> Supporting multiple users, one on each CRTC, has long been a feature
> request from people building low end educational systems, kiosks,
> Internet cafes, etc. If the entire graphics subsystem is going to get
> rewritten this feature should be added.


are you going to write the code?

this topic has been on the table for YEARS and no code appeared. The
patch here is a great step forward for the common case, and seems to
allow more complex setups either already or with some minor future
modifications.... so how about we move forward with this code that
exists today, instead of doing more vaporware while holding the rest of
the world back...


