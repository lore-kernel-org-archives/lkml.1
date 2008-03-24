Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYCXIZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYCXIZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCXIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:25:05 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:42166 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYCXIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qs0mYc1eyvsU4gqUVfpPqXmjp03V/urX2FTv7ynteh20AY8OlU6QmgjO38eQEwUOALkC39gsTxSH/8sSAqBBdwZpji/dECgqZQB0DlZZT0a90sY7KgmYFz0qxx21qfE4yK3Lh0wsOiT65FRaO9v9t3cgkcbwfuG7GCtnzs7Gxh0=
Message-ID: <38b2ab8a0803240125w639a1980madef7086d79bad82@mail.gmail.com>
Date: Mon, 24 Mar 2008 09:25:02 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Question about C language.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47E60773.2040409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0803210846p2f9b92adr951fe7fa0444de63@mail.gmail.com>
	 <47E60702.30302@redhat.com> <47E60773.2040409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 8:32 AM, Chris Snook <csnook@redhat.com> wrote:
>  Oops, forgot to mention, you should use atomic_t, to avoid aliasing
>  problems, and ALSO use explicit barriers wherever you need them.
>

Interesting, could you give me some pointers about aliasing please ?

Thanks
-- 
Francis
