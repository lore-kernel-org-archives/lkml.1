Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYHMQS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYHMQS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYHMQSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:18:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:1317 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHMQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TrTOYhXgTltU3salOTegLp0RtZuEBfuFGBuHTYXPGfr7NHFLEQwPXgxId5/ze1xGR+
         VLM/kFrF12/zcZVTDuORqWtYooQK1WzX++IY+NoAOtRyS6CdPDnrc3p7dlgOA94iEfGb
         gn0oNsvJtNIFrSaxwazlbeTa9hXXKsBuK9mdM=
Message-ID: <b6a2187b0808130918n1642c063j6ac4832792fca468@mail.gmail.com>
Date: Thu, 14 Aug 2008 00:18:43 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: timtas@cubic.ch
Subject: Re: reiser4 for 2.6.27-rc1
Cc: "Ryan Hope" <rmh3093@gmail.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Michael Krufky" <mkrufky@linuxtv.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Pavel Machek" <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48A2FCA2.4040603@cubic.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4896F56D.7080503@cubic.ch> <20080813125807.GC6995@ucw.cz>
	 <20080813131839.GB26351@cs181140183.pp.htv.fi>
	 <37219a840808130624p3d4dca0bja2935d6f34beaf7e@mail.gmail.com>
	 <48A2E391.3080404@cubic.ch>
	 <20080813143613.61101a5e@lxorguk.ukuu.org.uk>
	 <48A2E8EA.2060704@cubic.ch>
	 <48f7fe350808130759w18b887dcr1978ccf1c49d1c75@mail.gmail.com>
	 <48A2FCA2.4040603@cubic.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 11:24 PM, Tim Tassonis <timtas@cubic.ch> wrote:

> I can very well live with reiser4 not making it into mainline, I never used
> reiser3 (only once for two, and after a power outage rendered the fs
> unusable and fsck did fsck all, I chose reliability over "performance") and
> am quite happy with ext3 for years and btrfs looks promising, too.

I'm one who think reiser3 is great, and can't wait to see reiser4 in
the mainstream, so please don't just assume reiserfs is obsolete. It's
very much usable and very stable. So, if you don't use it, please
don't comment negatively on. And I am who is very appreciative of
Hans's contribution to Linux giving it a great journaling filesystem
to start with. Reiser4 may have tangent off track and annoyed many
smart developers, but please give it a chance to make Linux even
better.

Thanks,
Jeff.
