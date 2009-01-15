Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZAOXMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZAOXMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764330AbZAOXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:12:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:44449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764130AbZAOXM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:12:28 -0500
Date: Thu, 15 Jan 2009 15:05:16 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/85] 2.6.27.12-stable review
Message-ID: <20090115230516.GA19510@suse.de>
References: <20090115215812.GA17227@kroah.com> <vifvm49imd48dmmsbg34d44on2hevn6a6q@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vifvm49imd48dmmsbg34d44on2hevn6a6q@4ax.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 09:54:31AM +1100, Grant Coady wrote:
> On Thu, 15 Jan 2009 13:58:12 -0800, you wrote:
> >The whole patch series can be found in one patch at:
> >	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
> >and the diffstat can be found below.
> 
> Hey Greg, you hid the file?
> 
> $ wget http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
> --09:52:29--  http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.12-rc1.gz
>            => `patch-2.6.27.12-rc1.gz'
> Resolving kernel.org... 149.20.20.133, 204.152.191.37
> Connecting to kernel.org|149.20.20.133|:80... connected.
> HTTP request sent, awaiting response... 404 Not Found
> 09:52:29 ERROR 404: Not Found.

{sigh}  I knew I would mess something up...

It is there now, give it 10 minutes or so to replicate out to the public
servers.

Thanks for letting me know,

greg k-h
