Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbXLIM4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbXLIM4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXLIMz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:55:57 -0500
Received: from thunk.org ([69.25.196.29]:43777 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbXLIMz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:55:56 -0500
Date: Sun, 9 Dec 2007 07:55:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] random: step more rapidly through the pool when
	adding and extracting
Message-ID: <20071209125541.GA17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Mackall <mpm@selenic.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <2.753618428@selenic.com> <6.753618428@selenic.com> <20071209014820.GV17037@thunk.org> <20071208200055.00762c19.akpm@linux-foundation.org> <20071209042204.GR19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209042204.GR19691@waste.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 10:22:04PM -0600, Matt Mackall wrote:
> 
> It did. My laptop didn't relay them through my smarthost and my domain
> has an SPF record.

Ah, yes:

http://homepages.tesco.net/~J.deBoynePollard/FGA/smtp-spf-is-harmful.html

							- Ted

