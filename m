Return-Path: <linux-kernel-owner+w=401wt.eu-S1161006AbXBRGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbXBRGeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030361AbXBRGeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:34:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030358AbXBRGeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:34:37 -0500
Date: Sat, 17 Feb 2007 22:34:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm2
Message-Id: <20070217223434.add1229f.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970702172218k4d86d054w589768a0744315a4@mail.gmail.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<21d7e9970702172218k4d86d054w589768a0744315a4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 17:18:14 +1100 "Dave Airlie" <airlied@gmail.com> wrote:

> > - git-drm.patch is still in disgrace
> >
> 
> Okay I think I've fixed it up, some of the locking code from the DRM
> git devel repo was completely integrated..
> 

yep, my X server is happy now.
