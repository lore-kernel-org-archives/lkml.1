Return-Path: <linux-kernel-owner+w=401wt.eu-S1765367AbYBUL4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765367AbYBUL4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbYBULz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:55:58 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35383 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbYBULz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:55:57 -0500
Date: Thu, 21 Feb 2008 12:56:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: gorcunov@gmail.com, takata@linux-m32r.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] s390: cleanup - drop .data.idt section in vmlinux.lds script
Message-ID: <20080221115608.GA27508@uranus.ravnborg.org>
References: <20080220194123.114692303@gmail.com> <20080220194444.348896940@gmail.com> <1203593173.3489.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203593173.3489.1.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 12:26:13PM +0100, Martin Schwidefsky wrote:
> On Wed, 2008-02-20 at 22:41 +0300, gorcunov@gmail.com wrote:
> > The section .data.idt is not used at all - so drop it.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Martin - I expect you to take the patch as it only touches s390.
OK?

	Sam
