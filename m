Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXFVV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXFVV2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFVV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:28:04 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60062 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbXFVV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:28:01 -0400
Date: Fri, 22 Jun 2007 23:27:58 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070622212758.GA6970@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Arjan van de Ven <arjan@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com> <20070622211746.GB21769@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622211746.GB21769@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 06:17:46PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 22 Jun 2007, Carlo Wood wrote:
> > So far I found out that it's RAID only.
> 
> If you change the IO schedulers, does it help?

How do I do that?

-- 
Carlo Wood <carlo@alinoe.com>
