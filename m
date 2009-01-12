Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZALPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZALPul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZALPuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:50:32 -0500
Received: from genesysrack.ru ([195.178.208.66]:39536 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZALPuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:50:32 -0500
Date: Mon, 12 Jan 2009 18:50:30 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112155030.GA21063@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112154922.6003750b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:49:22PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Do you want to own a tame killer? Do you want to control the world?
> 
> We've got /proc/*/oom_adj already

Which has to be checked for every process ever created,
which is quite unfeasible in some conditions.

-- 
	Evgeniy Polyakov
