Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXHFQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXHFQJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXHFQI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:08:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXHFQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:08:58 -0400
Subject: Re: uclinux patches submission and author credit
From: Arjan van de Ven <arjan@infradead.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070806153620.GA8923@muff.macqel.be>
References: <20070806153620.GA8923@muff.macqel.be>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 06 Aug 2007 09:07:32 -0700
Message-Id: <1186416452.2706.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 17:36 +0200, Philippe De Muyter wrote:
> Hi Andrew and Greg,
> 
> Currently, all the patches that are submitted via Greg are marked as
> authored by Greg.  Actually, the author is named in the first
> Signed-off-by line (often Greg himself, sometimes someone other).
> 
> Would it be possible to fix the patch submission scheme so that the real
> author is credited ?

The easiest GIT way to do this is to put a 

From: <your name> 

in the body of the description; then everything automatically flows from
there..


