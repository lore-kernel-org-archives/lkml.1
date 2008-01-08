Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYAHIuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYAHIuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYAHIuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:50:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:18625 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYAHIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M1t8ef118OjsDjkOKMxqcrOFznViNjtmiKc4vJ7k5uavAtlx14yl7a9EG7V1ypv27V3YFI802jTFFv5n5coJddLraqAsAPWe/P88sxGLy/dKa8+zLnrbAQD3ORl/zRtXSmsL6ZXs1NZLuxYe6sVg64503OgIHmv/L5Zhv3C2lXY=
Message-ID: <84144f020801080049r487690ffv9f49c68160b205d2@mail.gmail.com>
Date: Tue, 8 Jan 2008 10:49:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: New linux arch
Cc: "Michal Simek" <simekm2@fel.cvut.cz>, linux-kernel@vger.kernel.org,
       monstr@monstr.eu
In-Reply-To: <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47820D24.3060800@fel.cvut.cz>
	 <386072610801080028w7bb9735cs7c104af146c0ab3d@mail.gmail.com>
X-Google-Sender-Auth: ea5d281f1efe1dab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Jan 8, 2008 10:28 AM, Bryan Wu <cooloney.lkml@gmail.com> wrote:
> 1. Push patches to LKML when merge window open (2 weeks after a stable
> kernel version release, for example 2 weeks after 2.6.24 released)

You shouldn't wait for the merge window to open to send patches for
review for the first time; otherwise you'll just miss the opportunity
to merge ;-).

                        Pekka
