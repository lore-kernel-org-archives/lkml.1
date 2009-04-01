Return-Path: <linux-kernel-owner+w=401wt.eu-S934271AbZDATsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbZDATsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZDATsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:48:18 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57686 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934255AbZDATsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:48:14 -0400
Date: Wed, 1 Apr 2009 15:48:10 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090401194810.GY3795@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net> <20090401165741.GA3797@csclub.uwaterloo.ca> <20090401190340.GA29673@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401190340.GA29673@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 09:03:40PM +0200, Sam Ravnborg wrote:
> They decided to fix it by eliminating the *_{no,mm}.h files for exported headers.
> The patch is already in mainline.

Oh good.  Yay!  Just didn't make it into 2.6.29 I suspect.  Well there
is always 2.6.30.

-- 
Len Sorensen
