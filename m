Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbYJMNSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbYJMNSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYJMNSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:18:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:60427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYJMNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:18:46 -0400
Date: Mon, 13 Oct 2008 09:18:48 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Phil Endecott" <phil_wueww_endecott@chezphil.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Mention Intel Atom in Kconfig.cpu
Message-ID: <20081013091848.7dcdaaac@infradead.org>
In-Reply-To: <87zll8r86h.fsf@basil.nowhere.org>
References: <1223895506638@dmwebmail.dmwebmail.chezphil.org>
	<87zll8r86h.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 14:28:06 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
> 
> > Am I right in thinking that CONFIG_MCORE2 is the correct choice for
> > an Intel Atom? 
> 
> No, Atom is completely different from a Core2.
> 
> Right now 586 or 686 is a reasonable choice.

actually 586 is completely wrong.

Core2 instruction set with tune=generic is still the best to set.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
