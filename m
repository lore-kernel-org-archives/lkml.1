Return-Path: <linux-kernel-owner+w=401wt.eu-S1030734AbXCSXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734AbXCSXZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030732AbXCSXZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:25:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33754 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966057AbXCSXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:25:36 -0400
Date: Mon, 19 Mar 2007 16:25:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-Id: <20070319162529.7724b150.akpm@linux-foundation.org>
In-Reply-To: <45FD8684.4030501@googlemail.com>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>
	<45FD8684.4030501@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 19:35:48 +0100
Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod

This is caused by git-kbuild.  I don't know what the significance of it is.
