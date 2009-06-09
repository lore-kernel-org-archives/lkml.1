Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbZFIEHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbZFIEHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 00:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZFIEHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 00:07:24 -0400
Received: from thunk.org ([69.25.196.29]:51077 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZFIEHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 00:07:24 -0400
Date: Tue, 9 Jun 2009 00:06:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 43/49] jbd2: Fix minor typos in comments in
	fs/jbd2/journal.c
Message-ID: <20090609040654.GA9299@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Bertogli <albertito@blitiri.com.ar>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1244488987-32564-36-git-send-email-tytso@mit.edu> <1244488987-32564-37-git-send-email-tytso@mit.edu> <1244488987-32564-38-git-send-email-tytso@mit.edu> <1244488987-32564-39-git-send-email-tytso@mit.edu> <1244488987-32564-40-git-send-email-tytso@mit.edu> <1244488987-32564-41-git-send-email-tytso@mit.edu> <1244488987-32564-42-git-send-email-tytso@mit.edu> <1244488987-32564-43-git-send-email-tytso@mit.edu> <1244488987-32564-44-git-send-email-tytso@mit.edu> <20090608194112.GB4852@blitiri.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608194112.GB4852@blitiri.com.ar>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:41:12PM -0300, Alberto Bertogli wrote:
> 
> There is a second version of the patch (the one you replied to) that has
> "function*s*" fixed.
> 

Thanks for pointing that out; I've edited the patch to change
"function" to "functions".

					- Ted
