Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZKPTjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZKPTjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZKPTjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:39:35 -0500
Received: from solo.fdn.fr ([80.67.169.19]:47020 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbZKPTja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:39:30 -0500
Date: Mon, 16 Nov 2009 20:08:35 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for non-ASCII
Message-ID: <20091116190835.GK4764@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, hpa@zytor.com, mgarski@post.pl
References: <20091116135114.GA2719@x200> <20091116144003.5983053e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116144003.5983053e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Mon 16 Nov 2009 14:40:03 +0000, a écrit :
> The assumptions seem reasonable and if not we'll find out. Either way its
> going to be an improvement.

Nope, it turns the caps lock into a shift lock, which is really not the
same.

Samuel
