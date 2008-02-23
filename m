Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYBWOjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYBWOjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYBWOjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:39:39 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:32313 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYBWOji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oWpSDoO3vbL5s2E1DngmXArNkL/btPZoMwPlMOZo+rKooiAHsXf+O5ogafCZKOJ8ChjHmOs7ddK777qqKXmQ1VjxqgjmwwB2ihxKhR4YkR6xuA/5SS5qmTEHwV9apc7m39s9L4DGjwrlzpAzdnDIkhuuY6NlCpe9nbgc+TyLWc4=
Date: Sat, 23 Feb 2008 17:39:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 08/10] IDE: Coding Style fixes to
	drivers/ide/pci/generic.c
Message-ID: <20080223143907.GE6747@cvg>
References: <20080223150547.5256e734@paolo-desktop> <20080223142909.GD6747@cvg> <4d8e3fd30802230637h3c16e1bm4d99341c9cc8d70c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30802230637h3c16e1bm4d99341c9cc8d70c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paolo Ciarrocchi - Sat, Feb 23, 2008 at 06:07:01PM +0330]
| > | -/**
| > | +/*
| > ^^^^^^^
| >
| > Hi Paolo, it seems you just broke kdoc structure
| 
| thank you for your comment, i didn't know that.
| Won't happen in future patches.

no problem ;)

| Bart, can you fix that or do you want me to re-create the series?
| 
| Ciao,
| --
| Paolo
| http://paolo.ciarrocchi.googlepages.com/
| 
		- Cyrill -
