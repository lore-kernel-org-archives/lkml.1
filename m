Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYLEJq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYLEJq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYLEJqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:46:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:51572 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751138AbYLEJqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:46:42 -0500
Cc: gregkh@suse.de, stable@kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 05 Dec 2008 10:46:39 +0100
From: "Randolf Pohl" <randolf.pohl@gmx.de>
Message-ID: <20081205094639.8800@gmx.net>
MIME-Version: 1.0
Subject: Re: [2.6.27] filesystem (ext3) corruption (access beyond end)
To: linux-kernel@vger.kernel.org
X-Authenticated: #47769897
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/MUCAjqh3MGAQVneEcPt9CApJ0mXg/qchoGH84Sn
 I64cUGWd+UKL8uHrIuHcco9gyAOQzyYGRNtg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: KJ1KaRRieSEqNkiKs3Yhsih+IGRvb4AG
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think, stable and gregkh should be CCed on this,
and yes, I guess this deserves some investigation.

Regards,

Randolf

http://lkml.org/lkml/2008/12/4/246

Folkert van Heusden wrote:

> Hi,
> 
> With 2.6.26 and 2.6.27 a system of mine (a P4 with HT and IDE disk)
> gets massive disk-corruption: in dmesg warnings for access beyond
> drive end.
> Now this bug did not happen in 2.6.18 (debian kernel) and it seems to
> be gone in 2.6.28-rc* as well.
> My question now is: should it still be investigated?
>
>
> Folkert van Heusden
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
