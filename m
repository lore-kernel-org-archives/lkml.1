Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYIWSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYIWSgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYIWSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:35:57 -0400
Received: from [198.145.64.141] ([198.145.64.141]:54929 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751721AbYIWSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:35:56 -0400
Date: Tue, 23 Sep 2008 11:11:29 -0700
From: Greg KH <greg@kroah.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 4/4] x86: Add sysfs entries for UV
Message-ID: <20080923181129.GC8661@kroah.com>
References: <20080922211051.GG222374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922211051.GG222374@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 04:10:51PM -0500, Russ Anderson wrote:
> [PATCH 4/4] Add sysfs entries for UV
> 
> Create /sys/firmware/sgi_uv sysfs entries for partition_id and coherence_id.

Please add the proper entries to Documentation/ABI/ for when you add new
sysfs files.

thanks,

greg k-h
