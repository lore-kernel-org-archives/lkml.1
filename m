Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYGUUnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYGUUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYGUUnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:43:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:59137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYGUUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:43:32 -0400
Date: Mon, 21 Jul 2008 13:43:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VT: Restore VT fonts on switch
Message-ID: <20080721134327.3ffab96f@infradead.org>
In-Reply-To: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 15:39:44 -0400
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Not all X drivers save and restore fonts on text VTs. Add code to the
> kernel to explicitly save and restore them on VT switches.


do you have a list of which ones don't ?
