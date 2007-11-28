Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbXK1Fie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbXK1Fie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXK1FiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:38:23 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbXK1FiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:38:22 -0500
Date: Tue, 27 Nov 2007 21:38:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.neta
Subject: Re: [uml-devel] leak in do_ubd_request
Message-Id: <20071127213801.4def3c23.akpm@linux-foundation.org>
In-Reply-To: <20071127222020.GA10096@c2.user-mode-linux.org>
References: <E1Ix3Du-0002aL-Ac@dorka.pomaz.szeredi.hu>
	<E1Ix58o-0004J5-Mz@dorka.pomaz.szeredi.hu>
	<20071127201105.GA9332@c2.user-mode-linux.org>
	<E1Ix73b-0004aI-Px@dorka.pomaz.szeredi.hu>
	<20071127222020.GA10096@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 17:20:20 -0500 Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, Nov 27, 2007 at 09:29:23PM +0100, Miklos Szeredi wrote:
> > Sure.  The patch works for me, but please check that it also makes
> > sense.
> 
> I did - it's a straight-forward leak and fix.
> 

Do we have any idea which patch this patch fixes?
