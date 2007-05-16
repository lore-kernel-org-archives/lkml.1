Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbXEPOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbXEPOP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXEPOPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:15:22 -0400
Received: from smtp.nokia.com ([131.228.20.172]:59113 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbXEPOPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:15:21 -0400
Subject: Re: [PATCH] LogFS take three
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, John Stoffel <john@stoffel.org>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Ingo Oeser <ioe-lkml@rameria.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mtd@lists.infradead.org, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Greg KH <greg@kroah.com>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1179324273.2859.230.camel@shinybook.infradead.org>
References: <20070515151919.GA32510@lazybastard.org>
	 <17994.1241.436841.681216@stoffel.org>
	 <20070515191926.GB1220@lazybastard.org>
	 <1179291255.2859.195.camel@shinybook.infradead.org>
	 <20070516110933.GA5472@lazybastard.org>
	 <20070516113434.GC20482@mail.shareable.org>
	 <20070516115003.GD5472@lazybastard.org>
	 <17995.2550.581854.8393@stoffel.org>
	 <20070516135318.GK5472@lazybastard.org>
	 <1179324273.2859.230.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 16 May 2007 17:13:39 +0300
Message-Id: <1179324819.3642.30.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 May 2007 14:13:39.0537 (UTC) FILETIME=[66AD5C10:01C797C4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 22:04 +0800, David Woodhouse wrote:
> On Wed, 2007-05-16 at 15:53 +0200, Jörn Engel wrote:
> > 
> > My experience is that no matter which name I pick, people will
> > complain
> > anyway.  Previous suggestions included:
> > jffs3
> > jefs
> > engelfs
> > poofs
> > crapfs
> > sweetfs
> > cutefs
> > dynamic journaling fs - djofs
> > tfsfkal - the file system formerly known as logfs
> 
> Can we call it jörnfs? :)

And it is essential to preserve "ö" and let Pavel enjoy :-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

