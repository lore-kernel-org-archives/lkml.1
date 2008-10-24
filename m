Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJXJY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJXJY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJXJYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:24:21 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:52486 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYJXJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:24:20 -0400
X-IronPort-AV: E=Sophos;i="4.33,476,1220220000"; 
   d="scan'208";a="16434302"
Date: Fri, 24 Oct 2008 11:24:18 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Robert Moss <robert.von.moss@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is about choice!
Message-ID: <20081024092418.GA10246@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Robert Moss <robert.von.moss@gmail.com>,
	linux-kernel@vger.kernel.org
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com> <20081023080459.GC5073@const.bordeaux.inria.fr> <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Moss, le Thu 23 Oct 2008 04:21:09 -0700, a écrit :
> Ok on both 2.6.24 AND 2.6.26, i get the same thing from vga=ask then scan,
> 0 F00  80x25
> 1 F01  80x50
> 2 F02  80x43
> 3 F03  80x28
> 4 F05  80x36
> 5 F06  80x36
> 6 F07  80x60

Could you try edd=off?

Samuel
