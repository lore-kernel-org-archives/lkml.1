Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbXF0QFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbXF0QFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXF0QE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:04:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56877 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXF0QE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:04:58 -0400
Subject: Re: Linux Kernel include files
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: harald@skogtun.org, david@lang.hm, linux-kernel@vger.kernel.org,
       schilling@fokus.fraunhofer.de
In-Reply-To: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 17:04:42 +0100
Message-Id: <1182960282.1170.4.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 16:00 +0200, Joerg Schilling wrote:
> Warning: *** linux/ext2_fs.h is not usable at all ***
> Warning: *** This makes it impossible to support Linux file flags ***
> You may try to compile using 'make COPTX=-DTRY_EXT2_FS'

Again, can you be _specific_? Amusing though your consistent 'Lunix is
broken' chants are, the only reason I'm bothering to participate in this
thread is on the off-chance that something _productive_ will come of it.

By the way, your mailer seems to be sometimes omitting In-Reply-To: and
References: headers, which RFC2822 says you SHOULD include in replies. 

-- 
dwmw2

