Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYK1HaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYK1HaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYK1HaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:30:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbYK1HaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:30:04 -0500
Message-ID: <492F9E14.8090106@cn.fujitsu.com>
Date: Fri, 28 Nov 2008 15:30:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: add link_css_set() to remove duplicate code
References: <492F9D50.9050603@cn.fujitsu.com>
In-Reply-To: <492F9D50.9050603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Add a common function link_css_set() to link a css_set to a
> cgroup.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I forgot the patch number..The title should be:

[PATCH 2/2] cgroups: add link_css_set() to remove duplicate code

