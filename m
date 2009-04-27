Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZD0GjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZD0GjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZD0GjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:39:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:44311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbZD0GjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:39:08 -0400
Subject: Re: [PATCH] ihex2fw should be ignored by scripts/.gitignore
 because ihex2fw is in scripts directory
From: David Woodhouse <dwmw2@infradead.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: jaharkes@cs.cmu.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20090427124333.a7270ddf.h.mitake@gmail.com>
References: <20090427124333.a7270ddf.h.mitake@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 07:39:02 +0100
Message-Id: <1240814342.30259.41.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 12:43 +0900, Hitoshi Mitake wrote:
> 
> I found this message from git-status on not modified clone of Linus's
> tree,
> 
> # Not currently on any branch.
> # Untracked files:
> #   (use "git add <file>..." to include in what will be committed)
> #
> #       scripts/ihex2fw
> nothing added to commit but untracked files present (use "git add" to
> track)

Actually, ihex2fw should never have been moved from the firmware/
directory to scripts/. I've already moved it back, so the .gitignore
files are correct as they are.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

