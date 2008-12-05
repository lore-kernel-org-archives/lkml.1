Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYLEJu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYLEJu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYLEJus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:50:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:52832 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751140AbYLEJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:50:48 -0500
Cc: stable@kernel.org, gregkh@suse.de
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 05 Dec 2008 10:50:45 +0100
From: "Randolf Pohl" <randolf.pohl@gmx.de>
In-Reply-To: <20081205094639.8800@gmx.net>
Message-ID: <20081205095045.144830@gmx.net>
MIME-Version: 1.0
References: <20081205094639.8800@gmx.net>
Subject: [resend] Re: [2.6.27] filesystem (ext3) corruption (access beyond end)
To: linux-kernel@vger.kernel.org, folkert@vanheusden.com
X-Authenticated: #47769897
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+fUSFsmHOfkck4amUe/fB35Nydkmsb4t2sS/SIQZ
 y7/lhTR8C/5GK8p6rtQAK0b0BgfmD0ljS7jg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: TMEOANt/QEV/fB7fsXdpjBdCNzg2NcJB
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend, forgot to CC original poster.

> I think, stable and gregkh should be CCed on this,
> and yes, I guess this deserves some investigation.
> 
> Regards,
> 
> Randolf
> 
> http://lkml.org/lkml/2008/12/4/246
> 
> Folkert van Heusden wrote:
> 
> > Hi,
> > 
> > With 2.6.26 and 2.6.27 a system of mine (a P4 with HT and IDE disk)
> > gets massive disk-corruption: in dmesg warnings for access beyond
> > drive end.
> > Now this bug did not happen in 2.6.18 (debian kernel) and it seems to
> > be gone in 2.6.28-rc* as well.
> > My question now is: should it still be investigated?
> >
> >
> > Folkert van Heusden
> -- 
> Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen:
> http://www.gmx.net/de/go/multimessenger

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
