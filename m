Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYEMPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYEMPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYEMPCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:02:00 -0400
Received: from lazybastard.de ([212.112.238.170]:42388 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYEMPB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:01:59 -0400
Date: Tue, 13 May 2008 17:01:43 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-mtd@lists.infradead.org, Bryan Wu <cooloney@kernel.org>,
       dwmw2@infradead.org, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Message-ID: <20080513150143.GA18026@logfs.org>
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org> <20080513080727.GA15795@logfs.org> <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0805130542x46f5e7fejf1347f1c71f567fb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 08:42:08 -0400, Mike Frysinger wrote:
> On Tue, May 13, 2008 at 4:07 AM, Jörn Engel wrote:
> > On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
> >  >
> >  > +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
> >
> >  Is this still needed?
> 
> yes

Can you elaborate a bit?

Jörn

-- 
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus
