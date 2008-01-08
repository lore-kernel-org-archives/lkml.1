Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYAHLwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYAHLwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYAHLwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:52:22 -0500
Received: from ozlabs.org ([203.10.76.45]:41023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392AbYAHLwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:52:21 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] track and print last unloaded module in the oops trace
Date: Tue, 8 Jan 2008 22:52:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       ak@suse.de
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org> <200801071225.37707.rusty@rustcorp.com.au> <20080108112331.GA1162@elte.hu>
In-Reply-To: <20080108112331.GA1162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082252.02718.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 22:23:31 Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > Right now, only the last 1 module is tracked; I expect that this is
> > > enough for the vast majority of cases where this information
> > > matters; if it turns out that tracking more is important, we can
> > > always extend it to that.
> > >
> > > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> >
> > Thanks, applied.
>
> needs the fix below.

Thanks, I rolled that in.

Cheers,
Rusty.

