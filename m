Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZBYHWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZBYHWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZBYHW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:22:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZBYHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:22:26 -0500
Date: Wed, 25 Feb 2009 02:22:02 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [rfc] headers_check cleanups break the whole world
Message-ID: <20090225072202.GI6690@bombadil.infradead.org>
References: <20090225032553.GD6690@bombadil.infradead.org> <20090225065632.GB21903@elte.hu> <20090225070511.GG6690@bombadil.infradead.org> <49A4EE85.5000907@zytor.com> <20090225071347.GH6690@bombadil.infradead.org> <49A4F051.3000706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4F051.3000706@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 11:16:33PM -0800, H. Peter Anvin wrote:
> Not all that bad, actually.
> 
> This is the last patch I've seen on the subject:
> 
> http://marc.info/?i=200902051707.55457.arnd@arndb.de
> 

Ah, excellent. I must have missed it (looks like Arnd didn't send it to
linux-arch@ as well. :)

Big ACK from me.

regards, Kyle
