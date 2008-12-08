Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYLHUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYLHUmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYLHUma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:42:30 -0500
Received: from kuber.nabble.com ([216.139.236.158]:58972 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYLHUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:42:29 -0500
Message-ID: <20903107.post@talk.nabble.com>
Date: Mon, 8 Dec 2008 12:42:28 -0800 (PST)
From: Dennis Hardy <dhardy@sogetthis.com>
To: linux-kernel@vger.kernel.org
Subject: Re: CIFS regression in 2.6.27.8
In-Reply-To: <200812082112.49468.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: dhardy@sogetthis.com
References: <20900699.post@talk.nabble.com> <84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com> <200812082112.49468.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> FWIW, it seems to be related to this one: http://lkml.org/lkml/2008/12/8/7
>
> Thanks,
> Rafael

Please note that in my case, I'm not seeing any samba log errors or any
problems with CPU utilization...  File read access via the CIFS mount seems
to work fine, it is just that "df" is reporting completely incorrect
information for the CIFS mount.


-- 
View this message in context: http://www.nabble.com/CIFS-regression-in-2.6.27.8-tp20900699p20903107.html
Sent from the linux-kernel mailing list archive at Nabble.com.

