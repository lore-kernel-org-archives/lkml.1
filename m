Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAVFiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAVFiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYAVFiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:38:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:38798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYAVFiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:38:12 -0500
Date: Mon, 21 Jan 2008 21:33:37 -0800
From: Greg KH <gregkh@suse.de>
To: Ian Brown <ianbrn@gmail.com>
Cc: linux-kernel@vger.kernel.org, kpm@linux-foundation.org
Subject: Re: sysfs network namespace support - was this patch set forgotten
	?
Message-ID: <20080122053337.GC7719@suse.de>
References: <d0383f90801192308h7888079cubb47daf6ec465d0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0383f90801192308h7888079cubb47daf6ec465d0f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 09:08:43AM +0200, Ian Brown wrote:
> Hello,
> 
> I saw some posts (from about a month ago) about network namespace
> support patches; I wonder: what
> is the status of this patch set ? was it somehow forgotten ?
> (I don't see it in v2.6.24-rc8 mm tree).

It wasn't "forgotten", but rather, not applied as Al Viro started to
have some serious questions about these changes...  I'll wait for his
review before applying them.

thanks,

greg k-h
