Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbXIRRNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbXIRRNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758367AbXIRRNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:13:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:47327 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbXIRRNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:13:35 -0400
Date: Tue, 18 Sep 2007 13:13:13 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Philipp Marek <philipp@marek.priv.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-ID: <20070918171313.GA6591@c2.user-mode-linux.org>
References: <200709181714.34035@x5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709181714.34035@x5>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 05:14:33PM +0200, Philipp Marek wrote:
> I'm trying to build a UML machine on x86-64 (config attached) 
> but I'm getting compile errors.

Builds for me.  Did you start with an mrproper?  These errors look
like the UML build getting confused by left-overs from an x86_64
build.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
