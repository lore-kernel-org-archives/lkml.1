Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbYCYSDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbYCYSDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYCYSDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:03:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:40805 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYCYSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PJ7i0ax6qieOZjoIDG4LlQXzKP9ID9+S2PpvexDMe02aIad6BBqtbCDGEuSd1lVHhA/IZJzn8oAsfgxCMvdK4NtTF+ymVTuIXIurMyY5q4DM0kZ3lqc7QJy3CdmaHJpH/ZQGun+yfVYVYnahUSPZdFCTa8PfdC4le9qSu7EFx+I=
Message-ID: <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
Date: Tue, 25 Mar 2008 11:03:37 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <47E9003B.5010002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242324.35357.yhlu.kernel@gmail.com>
	 <47E9003B.5010002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 6:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>  > [PATCH] x86: pat cpu feature bit setting for known cpus
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>  OK, note previous question: what is the motivation for having this as a
>  whitelist (as opposed to a blacklist)?

Venkatesh could tell?

YH
