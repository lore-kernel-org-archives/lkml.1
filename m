Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYKZQ24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYKZQ24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYKZQ2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:28:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYKZQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:28:48 -0500
Date: Wed, 26 Nov 2008 17:39:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: aperture_64.c: clarify that too small aperture is valid reason for this code
Message-ID: <20081126163911.GZ6703@one.firstfloor.org>
References: <20081126161527.GE1983@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126161527.GE1983@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 05:15:27PM +0100, Pavel Machek wrote:
> 
> Clarify that too small aperture is valid reason for this code.

There are lots more reasons than that, e.g. bad aperture pointing
somewhere invalid.  I'm not sure it makes sense to list them all.

-Andi
