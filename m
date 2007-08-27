Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbXH0Wxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbXH0Wxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXH0Wxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:53:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXH0Wx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:53:29 -0400
Date: Mon, 27 Aug 2007 15:53:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070827155302.47ba71e2@laptopd505.fenrus.org>
In-Reply-To: <20070827212723.GM4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070827212723.GM4121@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 23:27:23 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc2-mm2:
> >...
> >  git-alsa.patch
> >...
> >  git trees
> >...
> 
> sys_{open,read} can finally be unexported.
> 

isn't sys_close in the same boat?
