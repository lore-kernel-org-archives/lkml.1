Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZH3S1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZH3S1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 14:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZH3S1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 14:27:03 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:50105 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZH3S1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 14:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=BP5/MWGU9ZWYUfIngHEkP5hOO47X+QuMprBvEdSngKX2KaQl0p5gVO5ver7EmwuocP
         QHiFVdMNmIcB6RlTunzUZ048/643oF6Oz0MbpnW1dR0cl2pIV280dwfsxPYLv0hJbOEb
         SzDyo4D66VeJX8eax9XW8HmTKRzQJCV+5mWFY=
Date: Sun, 30 Aug 2009 11:26:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/input/keyboard: Move a dereference below a
	NULL test
References: <Pine.LNX.4.64.0908301117010.17060@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908301117010.17060@ask.diku.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090830185928.613DB526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 11:18:13AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereference should be moved below
> the NULL test.
> 

Applied, thank you Julia.

-- 
Dmitry
