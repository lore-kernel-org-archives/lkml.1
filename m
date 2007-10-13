Return-Path: <linux-kernel-owner+w=401wt.eu-S1759530AbXJMNSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbXJMNSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 09:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXJMNSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 09:18:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52406 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXJMNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 09:18:45 -0400
Subject: Re: [PATCH] v4l: copy_to_user() is not a good method name
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071013072524.GF8181@ftp.linux.org.uk>
References: <20071013072524.GF8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Date: Sat, 13 Oct 2007 10:20:19 -0300
Message-Id: <1192281619.8616.1.camel@areia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-1mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Sáb, 2007-10-13 às 08:25 +0100, Al Viro escreveu:
> Breaks on any target that has copy_to_user() defined as a non-trivial
> macro.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>


Cheers,
Mauro

