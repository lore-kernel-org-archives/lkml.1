Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYGKNBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYGKNBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYGKNBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:01:01 -0400
Received: from bu3sch.de ([62.75.166.246]:59373 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYGKNBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:01:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
Date: Fri, 11 Jul 2008 15:00:29 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
References: <200807101914.10174.mb@bu3sch.de> <200807102112.09532.mb@bu3sch.de> <20080710163354.0cf75932@gaivota>
In-Reply-To: <20080710163354.0cf75932@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111500.29342.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 21:33:54 Mauro Carvalho Chehab wrote:
> On Thu, 10 Jul 2008 21:12:09 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > One alternative would be to make the gpio driver dependent of !VIDEO_BT848.  
> > 
> > +config GPIO_BT8XX
> > +       tristate "BT8XX GPIO abuser"
> > +       depends on PCI && VIDEO_BT848=n
> 
> Seems fine to me.

This is what's currently in the code. So I'm not sure what you are
complaining about. I'm confused.

-- 
Greetings Michael.
