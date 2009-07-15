Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZGOTlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZGOTlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZGOTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:41:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41213
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854AbZGOTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:41:46 -0400
Date: Wed, 15 Jul 2009 12:41:50 -0700 (PDT)
Message-Id: <20090715.124150.120992830.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ide-tape: misc stuff
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090715184350.GA13708@liondog.tnic>
References: <1247671100-8173-1-git-send-email-petkovbb@gmail.com>
	<20090715.111606.193724419.davem@davemloft.net>
	<20090715184350.GA13708@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Wed, 15 Jul 2009 20:43:50 +0200

> Well, the downside to that is whenever there's a bug report and I want
> the user to do a debug build and send me the output, I'll have to rehash
> that debug patch and send it to her/him, maybe teach her/him how to
> patch a kernel, build it and catch the output and send it my way before
> we do some real work. Having the change upstream makes it _a_ _lot_
> _more_ easier to do that and this is experience talking, we had several
> scenarious like that already.

Your PFX patch has no effect at all, it's just cleanup noise.

The other patch moves the debug mask from one place to another,
why can't the debug selections bet set properly as is?
