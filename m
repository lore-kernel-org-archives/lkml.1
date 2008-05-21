Return-Path: <linux-kernel-owner+w=401wt.eu-S933066AbYEUO2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066AbYEUO2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYEUO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:28:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36110 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYEUO2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:28:35 -0400
Date: Wed, 21 May 2008 07:28:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tarkan Erimer <tarkan@netone.net.tr>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion About Kernel Releases
Message-ID: <20080521072813.69ae2b0e@infradead.org>
In-Reply-To: <48342ADC.3030509@netone.net.tr>
References: <48341ED5.7060508@netone.net.tr>
	<20080521063855.0bdb441c@infradead.org>
	<48342ADC.3030509@netone.net.tr>
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

On Wed, 21 May 2008 16:59:56 +0300
Tarkan Erimer <tarkan@netone.net.tr> wrote:

> Arjan van de Ven wrote:
> > what would you want to accomplish with your idea?
> >   
> 
> To make kernel releases more stable/tested via "testX" series, as 
> recently discussed by David Miller's "Slow DOWN, please!!!" thread. 
> These "testX" releases will give more opportunity and time to test
> more these new releases. Also, with the aim of the "testX" series,
> the new kernel release schedules/merge windows will be not slow down.
> Even, Linus can releases new kernels more quickly. Because, testing
> purpose should be handled by someone else like Chris did for 2.6.x.y.

sorry but you're wrong ;(
calling something -test won't change anything. It just means it'll get
tested less, not more.


Also the "Slow DOWN please" had NOTHING to do with releases, but only
with what happens during the actual merge window.
