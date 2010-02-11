Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0BKKD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:03:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58675 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0BKKD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:03:57 -0500
To: Dan Carpenter <error27@gmail.com>
CC: error27@gmail.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20100211085120.GF14210@bicker> (message from Dan Carpenter on
	Thu, 11 Feb 2010 11:51:20 +0300)
Subject: Re: bug list: putting too much data on the stack
References: <20100211085120.GF14210@bicker>
Message-Id: <E1NfVtq-0002pE-8A@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 11:03:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Thu, 11 Feb 2010, Dan Carpenter wrote:
> fs/fuse/dev.c +888 fuse_notify_inval_entry(5) warn: 'buf' puts 1025 bytes on stack

The fix for this is already in linux-next.

Thanks,
Miklos
