Return-Path: <linux-kernel-owner+w=401wt.eu-S965572AbXHaNmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572AbXHaNmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965156AbXHaNmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:42:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964971AbXHaNmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:42:38 -0400
Message-ID: <46D81ACC.4080708@suse.de>
Date: Fri, 31 Aug 2007 15:42:36 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Denys Vlasenko <vda.linux@googlemail.com>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
References: <200708252257.07241.vda.linux@googlemail.com> <200708281256.35162.vda.linux@googlemail.com> <20070828081710.4687185c@laptopd505.fenrus.org> <200708282055.07411.vda.linux@googlemail.com> <Pine.LNX.4.64.0708302042260.24730@fbirervta.pbzchgretzou.qr> <20070830190235.GX14130@parisc-linux.org> <Pine.LNX.4.64.0708302150500.24730@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708302150500.24730@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 30 2007 13:02, Matthew Wilcox wrote:
>>> Well, you can send it to Linus/Andrew, that will usually upset people and they
>>> start commenting on it. Or they don't, and everything is fine.
>>> (The "default y" approach so to speak ;-)
>> The problem is that we don't really have a maintainer for the aic7xyz
>> drivers any more.  Volunteers welcome.  NOT IT!
> 
> Take it before someone else does!
> 
Well, the semi-official maintainers are James B. and me.

So I might as well do it officially.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
