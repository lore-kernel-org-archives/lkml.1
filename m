Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017Ab0AGGtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0AGGtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590Ab0AGGtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:49:52 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:54378 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0AGGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AFvrQNpih6TqTTyrXi7cPe/2YiH0z0MFHUH47RLAe3jhXC/y8A7DnMzuaL9XY4hCIL
         W6E7onEbpT6fInsBuDhPQjCVIiT+B00lvwvixXSdxSgJrkeTvp0KUIRjP1w+Ue00Bfv/
         XfWQzbJ2W++FVoXZwnpNa4Dc4SfM4siaiuLlc=
MIME-Version: 1.0
In-Reply-To: <1261413866-30634-1-git-send-email-vapier@gentoo.org>
References: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com> 
	<1261413866-30634-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 7 Jan 2010 01:49:31 -0500
Message-ID: <8bd0f97a1001062249l2659fe4blaa76342ec4f621dd@mail.gmail.com>
Subject: Re: [uClinux-dev] [PATCH] nommu: implement vmap/vunmap with kmalloc
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:44, Mike Frysinger wrote:
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@7693 526b6c2d-f592-4532-a319-5dd88ccb003d

blah, didnt realize i still had this crap.  drop the changelog and add:
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
