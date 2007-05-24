Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbXEXSAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbXEXSAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbXEXR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:59:55 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:59128 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbXEXR7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:59:54 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Diego Calleja <diegocg@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Date: Thu, 24 May 2007 21:01:02 +0300
User-Agent: KMail/1.9.7
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
References: <2172422218943432279@wsc.cz> <20070524193805.1b5d37d9.diegocg@gmail.com>
In-Reply-To: <20070524193805.1b5d37d9.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705242101.03537.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 20:38:05 Diego Calleja wrote:
> El Thu, 24 May 2007 16:01:33 +0200 (CEST), Jiri Slaby <jirislaby@gmail.com> 
escribió:
> > +config USB_STK11XX
> > +	tristate "STK11XX based webcams"
> > +	depends on VIDEO_V4L2
> > +	---help---
> > +	  This will add support for Syntek webcams such as dc1125 and stk1135.
> > +
> > +	  If you choose to build it as module, it will be called stk11xx.
>
> Maybe this is a too picky requeriment, but IMO it would be nice if the
> module would be called "camera_stk11xx", or had any other prefix that gives
> some meaning about what is doing. It's hard to decipher from the name when
> you run lsmod.

That would be too picky indeed since other camera modules have no camera_ 
prefix like pwc,spca5xx, etc.

Regards,
ismail

-- 
Perfect is the enemy of good
