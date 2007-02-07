Return-Path: <linux-kernel-owner+w=401wt.eu-S1161333AbXBGXfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161333AbXBGXfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161416AbXBGXfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:35:07 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:32799 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161333AbXBGXfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:35:06 -0500
Date: Thu, 8 Feb 2007 00:34:50 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Oleg Verych <olecom@flower.upol.cz>
cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch, fix build regression] kbuild: Kbuild.include avoid using
 spaces in call arguments
In-Reply-To: <20070207220435.GC22699@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0702080029030.14457@scrub.home>
References: <20070207165204.GA5537@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0702071846180.14457@scrub.home> <20070207220435.GC22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 7 Feb 2007, Oleg Verych wrote:

> > Linus, please revert. Thanks.
>  
> Roman, while it went so fast to Linus, i didn't expect that, let me
> try to fix all this with this little patch.

Sorry, it needs more changes, the patch simply wasn't ready.

bye, Roman
