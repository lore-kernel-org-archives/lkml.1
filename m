Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYJPTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYJPTxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbYJPTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:52:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61815 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbYJPTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=jeo+KFOkHLrFSLG7S6pJofrLvTtBLEAJF77z0WyOVJKbvN6eqfgHXSJKWVqWQFVFjg
         d9FmOExMCNp8Eb9evwY6qHe1HlyQzNFKg0L5M8OvZNDIXBc/80aJa+Itr8kQGmbN+69n
         B5H8fD+kxYXJk+H/u20GJsf5hjIoAZ27wi+qo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-cd: remove obsolete seek optimization
Date: Thu, 16 Oct 2008 21:41:25 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200810152147.47534.bzolnier@gmail.com> <20081016054238.GB32756@gollum.tnic>
In-Reply-To: <20081016054238.GB32756@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810162141.25832.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Borislav Petkov wrote:
> On Wed, Oct 15, 2008 at 09:47:47PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > It doesn't make much sense nowadays and is problematic on some drives.
> 
> This is a big chunk, after all. We should do more hammering on it though, just
> to be sure.

yep, this is meant for .29
