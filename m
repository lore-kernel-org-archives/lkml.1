Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbXJPQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbXJPQA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbXJPQAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:00:14 -0400
Received: from cavan.codon.org.uk ([78.32.9.130]:38763 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbXJPQAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:00:13 -0400
Date: Tue, 16 Oct 2007 16:59:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Message-ID: <20071016155958.GA23322@srcf.ucam.org>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org> <20071016141153.GA3237@khazad-dum.debian.net> <d120d5000710160727w3267b9a4td25d155d816ecee8@mail.gmail.com> <20071016145412.GC21749@srcf.ucam.org> <d120d5000710160854p74d9944l7ba3c00fda93f674@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710160854p74d9944l7ba3c00fda93f674@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:54:31AM -0400, Dmitry Torokhov wrote:

> I think there was a laptop that sent vierd bytes over KBC port when
> you plug AC cord into it and pulled it out again. So it's not only
> keys. Don't have a reference handy though.

That rings a bell. We can already get that information from other 
sources, though, so I'm not sure it's necessary to implement a way of 
splitting it out.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
