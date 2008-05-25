Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYEYJLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYEYJLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYEYJLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:11:40 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:54079 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYEYJLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:11:39 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: some numbers on macros
Date: Sun, 25 May 2008 11:11:36 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200805241748.19607.m.kozlowski@tuxland.pl> <200805250141.09195.m.kozlowski@tuxland.pl> <20080524164615.0ed80f85@infradead.org>
In-Reply-To: <20080524164615.0ed80f85@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251111.36932.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Sun, 25 May 2008 01:41:09 +0200
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> > 
> > Interesting part would be to write a 'parser' that actually sees the
> > context and understands cpp directives, that could 'walk' the tree.
> 
> you could approach it from the opposite angle... I mean, lxr.linux.no
> already has all this data in some database.. maybe you can turn it into
> a set of database queries ;)

Good point :) Will look into this.

	Mariusz
