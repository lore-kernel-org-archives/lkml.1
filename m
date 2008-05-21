Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYEUEs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYEUEs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYEUEsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:48:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYEUEsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:48:18 -0400
Date: Tue, 20 May 2008 21:47:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
Message-ID: <20080520214759.1a210297@infradead.org>
In-Reply-To: <48336039.3010308@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
	<20080520152843.CF4181B4205@basil.firstfloor.org>
	<20080520085830.22c99115@infradead.org>
	<483318AE.2090306@firstfloor.org>
	<20080520130624.089ebf19@infradead.org>
	<48336039.3010308@firstfloor.org>
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

On Wed, 21 May 2008 01:35:21 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> 
> > My concern is that the new API as long lived is ugly and not the
> > right thing. I assume Linus and others have similar concerns, and
> > weigh that over the "some obscure out of tree driver might break".
> 
> What do you find ugly exactly? The prefix "unlocked_" ?

yes exactly

