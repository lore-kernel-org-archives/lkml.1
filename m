Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYGBIUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYGBIUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGBITv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:19:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56720 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYGBITu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:19:50 -0400
Message-ID: <486B39C0.1040507@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 16:18:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [-mmotm] some different buliding failures
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702011452.37bcec2f.akpm@linux-foundation.org>
In-Reply-To: <20080702011452.37bcec2f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 02 Jul 2008 14:23:28 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type
> 
> OK, this monstrosity seems to make it compile:
> 

Yes, it passed compile with my config. :)
