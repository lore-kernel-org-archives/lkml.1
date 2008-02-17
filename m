Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYBQWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYBQWvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYBQWvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:51:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:23169 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYBQWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pjaIwRxj2AYjN3MKT3l4VgJXuC18D5bBB25P5zCFS+qynNMQ5aJM0IUBsCpIHsq5u/MZGR5OeJ+Y1TRX++PycU3bvt/ZiFtOSkMkbqvvUQib8JgI4iRL4Wy8mIkzenD1/eR86cQfXdnmMSvYiR4jTwZVX901C+Za//qydJSXmI4=
Message-ID: <86802c440802171451p2728b29dnaf68a76dadcea21@mail.gmail.com>
Date: Sun, 17 Feb 2008 14:51:36 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jasper Bryant-Greene" <jasper@unix.geek.nz>
Subject: Re: 2.6.25-rc1 on Sun Ultra 40
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1202929484.10687.1.camel@phobos.jasper.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202901908.11100.8.camel@phobos.jasper.bg>
	 <1202929484.10687.1.camel@phobos.jasper.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 11:04 AM, Jasper Bryant-Greene <jasper@unix.geek.nz> wrote:
> I can confirm neither the boot hang with HPET enabled nor the other
> unexplained boot hang after "NET: Registered protocol family 2" occur on
> 2.6.24.2 on the same hardware. I still don't have an appropriate way to
> debug the issue on 2.6.25-rc1, though...

boot message with debug in command line

also .config please

YH
