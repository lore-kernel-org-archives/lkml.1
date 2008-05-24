Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYEXXrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYEXXrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYEXXre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:47:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39813 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYEXXre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:47:34 -0400
Date: Sat, 24 May 2008 16:46:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Matthew Wilcox <matthew@wil.cx>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: some numbers on macros
Message-ID: <20080524164615.0ed80f85@infradead.org>
In-Reply-To: <200805250141.09195.m.kozlowski@tuxland.pl>
References: <200805241748.19607.m.kozlowski@tuxland.pl>
	<20080524093350.60e6dc8d@infradead.org>
	<20080524185201.GZ2638@parisc-linux.org>
	<200805250141.09195.m.kozlowski@tuxland.pl>
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

On Sun, 25 May 2008 01:41:09 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> Interesting part would be to write a 'parser' that actually sees the
> context and understands cpp directives, that could 'walk' the tree.


you could approach it from the opposite angle... I mean, lxr.linux.no
already has all this data in some database.. maybe you can turn it into
a set of database queries ;)
