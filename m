Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYE0XuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYE0XuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYE0XuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:50:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42311 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYE0XuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:50:01 -0400
Date: Tue, 27 May 2008 16:49:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: mrenzmann@otaku42.de, linux-kernel@vger.kernel.org
Subject: Re: madwifi && v2.6.26-rc4
Message-ID: <20080527164938.709e53f6@infradead.org>
In-Reply-To: <6101e8c40805271623xb316cd0i47320ec566c0ba02@mail.gmail.com>
References: <6101e8c40805270820r5984ceddmcc9ee1137e097b9e@mail.gmail.com>
	<20080527105123.1c154daf@infradead.org>
	<6101e8c40805271623xb316cd0i47320ec566c0ba02@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 01:23:06 +0200
"Oliver Pinter" <oliver.pntr@gmail.com> wrote:

> On 5/27/08, Arjan van de Ven <arjan@infradead.org> wrote:
> > On Tue, 27 May 2008 17:20:23 +0200
> > "Oliver Pinter" <oliver.pntr@gmail.com> wrote:
> >
> >> Hi all!
> >>
> >> os: debian lenny
> >> madwifi 0.9.3.3
> >
> >
> > you probably want to use ath5k instead since you're posting to this
> > list.....

> jah, i know, that the ath5k is the official driver, but ath5k don't
> supported WPA2-PSK.
> I cc-ed mrenzmann, hi is the madiwifi webmaster / maintainer


but you posted to the linux-kernel mailing list, which is about an open
source project.... if you want to ask questions about proprietary
stuff, you're just better off asking the vendor of said module.... not
lkml, for which your question is basically off-topic.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
