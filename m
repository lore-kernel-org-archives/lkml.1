Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXKELi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXKELi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXKELiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:38:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:35866 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXKELit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:38:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uPddJzcmR/hrV3dQ2Xx19mlBdyh6pUSAqC2AlkcCc/5BLKf0oLgd0z8Dp8NzNUpHXnvf7JcmPFm8z9f8fxkWvKpdY5g8qIhoVDj0Sgjsbq++c+PT44/RlKXioe61PZ6VkG2cncUsbMRr2qXNwI5MsytNPAy+mhiDBCX9LPGkOSE=
Message-ID: <e5bfff550711050338g1e944e3g7b262063d307a396@mail.gmail.com>
Date: Mon, 5 Nov 2007 12:38:48 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: duplicated include files
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0711051146070.28623@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550711041141h612a24cdrcdb5baa35907989d@mail.gmail.com>
	 <Pine.LNX.4.62.0711051146070.28623@pademelon.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
>
> Are you building in a different tree than the source tree? The patch below
> fixed it for me.
>

Yes, I am. Thanks for the patch.

Marco
