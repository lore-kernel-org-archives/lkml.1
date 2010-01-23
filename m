Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717Ab0AWWoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0AWWoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 17:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413Ab0AWWoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 17:44:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0AWWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 17:44:13 -0500
Date: Sat, 23 Jan 2010 14:43:56 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
       adkulkar@umail.iu.edu
Subject: Re: NFS_FSCACHE still depends on EXPERIMENTAL?
In-Reply-To: <20100123143040.49f47e0d@infradead.org>
Message-ID: <alpine.DEB.2.01.1001231440430.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001231314480.3483@bogon.housecafe.de> <20100123143040.49f47e0d@infradead.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+P5oPEvyDXtguAEcuaSAuVIc26aVxyfVyUc3c
 cBPuyfJuN3qKdymkcesivU4PLqLItjgZOploPV8w4Q3GjfMaVU
 qbeAoc09GUehD2Iv6qGgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010 at 14:30, Arjan van de Ven wrote:
> since the EXPERIMENTAL flag more or less means nothing, the
> "it is marked with the flag so we don't do it" is reasoning based on
> more or less nothing...

Understood, but...if EXPERIMENTAL "more or less means nothing" (is this a 
general consensus?), why is the flag still used at all? IOW, would a patch 
removing all EXPERIMENTAL flags from all(!) options be accepted?

Thanks,
Christian.
-- 
BOFH excuse #160:

non-redundant fan failure
