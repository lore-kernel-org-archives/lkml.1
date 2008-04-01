Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbYDAJb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYDAJb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbYDAJbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:31:49 -0400
Received: from lazybastard.de ([212.112.238.170]:54135 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbYDAJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:31:48 -0400
Date: Tue, 1 Apr 2008 11:31:36 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401093136.GD7465@logfs.org>
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <20080401090309.GA7465@logfs.org> <47F1FBCF.2090902@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F1FBCF.2090902@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 12:09:35 +0300, Artem Bityutskiy wrote:
> Jörn Engel wrote:
> >About a year ago I would have used roughly the same argument.  But in
> >the meanwhile I have accepted the fact that any piece of flash I'll use
> >in a notebook in the next five years will likely use SATA or USB as a
> >transport medium.
> 
> Well, Thomasz was talking not about the transport I believe.

When the day comes and I can actually use raw flash with a SATA or USB
transport medium, I will be more careful and not imply that they all
expose a block device interface.  Today they do.

[ With the exception of Alauda, which has a userbase of about 1 - me. ]

Jörn

-- 
It does not matter how slowly you go, so long as you do not stop.
-- Confucius
