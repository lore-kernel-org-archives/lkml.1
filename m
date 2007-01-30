Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXA3KwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXA3KwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXA3KwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:52:16 -0500
Received: from iona.labri.fr ([147.210.8.143]:53592 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXA3KwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:52:15 -0500
X-Greylist: delayed 1641 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 05:52:15 EST
Date: Tue, 30 Jan 2007 11:24:51 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070130102451.GE3466@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-kernel@vger.kernel.org, libc-alpha@sources.redhat.com
References: <20070129145227.GA10524@2ka.mipt.ru> <40f323d00701290747y68c8e27ege824694bfa378f58@mail.gmail.com> <20070130011817.GI3541@interface.residence.ens-lyon.fr> <20070130095316.GD2455@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070130095316.GD2455@2ka.mipt.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov, le Tue 30 Jan 2007 12:53:16 +0300, a écrit :
> > You may want to have a look at some existing implementations:
> 
> I saw most of them.
> As far as I recall, only PTL (is not shown here) has preemptible
> scheduler. NTL has it too, but is based on different approach.

Marcel has a preemptible scheduler too, based on signals and
setjmp/longjmp.

Samuel
