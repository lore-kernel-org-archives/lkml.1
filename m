Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0BOQQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:16:07 -0500
Received: from bamako.nerim.net ([62.4.17.28]:59628 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab0BOQQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:16:02 -0500
Date: Mon, 15 Feb 2010 17:15:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: ebiederm@xmission.com (Eric W. Biederman), lasse.collin@tukaani.org,
       mirrors@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100215171559.19f2b56c@hyperion.delvare>
In-Reply-To: <20100214142729.78d8bc19@nehalam>
References: <4B744E13.8040004@kernel.org>
	<m1bpfritjg.fsf@fess.ebiederm.org>
	<20100214142729.78d8bc19@nehalam>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 14:27:29 -0800, Stephen Hemminger wrote:
> On Sun, 14 Feb 2010 10:03:31 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > Right now xz suffers from limited availability.  I just checked the
> > systems I have handy and of the 4 distro's I have installed on various
> > machines only 1 provides xz, so I expect it will be a while before
> > xz achieves ubiquity.  At the same time the fact that xz reduces
> > the linux-2.6.32 tarball by 10Megs is a welcome benefit, and seems
> > to make the replacement of bzip2 with xz worth doing.
> 
> xv is not standard on Ubuntu.
> Installing xv-utils on Ubuntu 9.10 produces big scary warning
> about package conflict with lzma.
> 
> This seems like a premature optimization at this point

That would be a packaging bug, xz should transparently supersede lzma.

-- 
Jean Delvare
