Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXHORNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXHORNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXHORN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:13:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46305 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbXHORN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:13:27 -0400
Date: Wed, 15 Aug 2007 13:12:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nicolas George <nicolas.george@normalesup.org>
Cc: linux-kernel@vger.kernel.org, uml-devel@lists.sourceforge.net
Subject: Re: UML/man: BLKGETSIZE takes a long, not an int
Message-ID: <20070815171247.GA7948@c2.user-mode-linux.org>
References: <20070813124247.GA7414@she-seel.salle-s.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813124247.GA7414@she-seel.salle-s.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:42:47PM +0200, Nicolas George wrote:
> I found a type mismatch in UML that makes host block devices unusable as ubd
> devices on x86_64 and other 64 bits systems (segfault of the mm subsystem):

Looks sane, can I have a properly Signed-off-by: version of the patch?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
