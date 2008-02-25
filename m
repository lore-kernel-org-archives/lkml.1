Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYBYWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYBYWRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYBYWR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:17:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:18768 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbYBYWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eZDw7sL2rr4CPNDwg5wfpiiukcECl+B7qW2NkohJQB7dYcdJWLFyS86/uaec1KTBv4ZHfOUu5GHSi/989D+p/Kat3nwT+F3iiNCwRHN23vboTb0KeJVvr9UDueBq+Vbq/low91nXhX+cLO6Pno9F6vbF6GcHWwMyX0i5yHw26oQ=
Message-ID: <8499950a0802251417l7a2fff25q7fa57fce57369b1b@mail.gmail.com>
Date: Mon, 25 Feb 2008 23:17:23 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Steve Brokenshire" <sbrokenshire@xestia.co.uk>
Subject: Re: [PATCH] Compress kernel modules on installation.
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:42 PM, Steve Brokenshire:
> Hi,
>
>  (I've sent this to the linux-kbuild and linux-kernel lists as this
>  patch modifies the Makefile.modinst file. I also don't subscribe to the
>  linux-kbuild and linux-kernel mailing lists so can I have any replies
>  CC'ed to me please)

And what if i like bzip2 (yea sometimes better) or 7zip (better if !EMBEDDED)
or whatever?

It's pure user/distro question.
_______
