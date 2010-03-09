Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0CIB0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:26:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44177 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab0CIBZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:25:58 -0500
Date: Tue, 9 Mar 2010 01:25:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Luca Barbieri <luca.barbieri@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309012552.GR30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <20100308184521.GK30031@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
 <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 02:18:13AM +0100, Luca Barbieri wrote:
> 4. It doesn't matter at all if anyone reads a file that happens to be
> at /etc/shadow while not containing shadow passwords (with the same
> path, but different content)

What the hell are you smoking?
