Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbZLKVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbZLKVTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbZLKVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:19:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41065 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbZLKVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vN+Tz9Elg/mTvej9Z2pgFY+21a/Hv4AE4Gbv8V7cdFMNUaKJ4v/btkurOlmA/oYCcg
         vaQDxVsDZTditl1e4gv+reNd3SwLrVPhXe8oZfX5VaJybq3k0VLHSnzs6Q4WAGLJ9TfL
         hACU13mZcaIsBKfKw5ptEv44bEUkSkGftdP/o=
Date: Fri, 11 Dec 2009 22:19:38 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: K8 ECC error with linux-2.6.32
Message-ID: <20091211211938.GB6246@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:02:47PM +0100, Johannes Hirte wrote:
> With kernel 2.6.32 I get now:
> 
> Dec 11 21:26:37 datengrab kernel: Northbridge Error, node 0, core: -1
> Dec 11 21:26:37 datengrab kernel: K8 ECC error.

Is that all, i.e. do you have anything else in the logs. For example, a
line which contains "MC?_STATUS: ..." or similar. Please send the whole
dmesg.

Thanks.

-- 
Regards/Gruss,
    Boris.
