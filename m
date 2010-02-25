Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0BYRVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:21:42 -0500
Received: from xenotime.net ([72.52.64.118]:43150 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932989Ab0BYRVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:21:40 -0500
Message-ID: <4B86B1A3.2090606@xenotime.net>
Date: Thu, 25 Feb 2010 09:21:39 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: linux-next: Tree for February 25 (quota)
References: <20100225183523.80361261.sfr@canb.auug.org.au>
In-Reply-To: <20100225183523.80361261.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/10 23:35, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100224:


When CONFIG_BLOCK=n:

fs/quota/dquot.c:2042: error: implicit declaration of function 'fsync_bdev'

-- 
~Randy
