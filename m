Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0BNW1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:27:53 -0500
Received: from mail.vyatta.com ([76.74.103.46]:56346 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab0BNW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:27:51 -0500
Date: Sun, 14 Feb 2010 14:27:29 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214142729.78d8bc19@nehalam>
In-Reply-To: <m1bpfritjg.fsf@fess.ebiederm.org>
References: <4B744E13.8040004@kernel.org>
	<m1bpfritjg.fsf@fess.ebiederm.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 10:03:31 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Right now xz suffers from limited availability.  I just checked the
> systems I have handy and of the 4 distro's I have installed on various
> machines only 1 provides xz, so I expect it will be a while before
> xz achieves ubiquity.  At the same time the fact that xz reduces
> the linux-2.6.32 tarball by 10Megs is a welcome benefit, and seems
> to make the replacement of bzip2 with xz worth doing.

xv is not standard on Ubuntu.
Installing xv-utils on Ubuntu 9.10 produces big scary warning
about package conflict with lzma.

This seems like a premature optimization at this point

-- 
