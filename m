Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYDHTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYDHTcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYDHTcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:32:03 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:42529 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbYDHTcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:32:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uvt3fx+Q/GATHaYvafAwckXXJ6bHjdOR6AubcNsNWyuOOGnz5CEM51Xtj83MjcpX3KRk8RMHOSEGJlKlhkZP44mRktLR4+Wzg9/vX5iWXLrpibmyk6TdfZRIMoh6j05UWcnMPxj0JzlBGK2J+YN/PnEqvMbxqIb30QVqOF/osQs=
Message-ID: <36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
Date: Tue, 8 Apr 2008 21:32:00 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080408184302.113424000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184302.113424000@polaris-admin.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>   * Add cpu_sysdev_class functions to display the following maps
>     with cpulist_scnprintf().
>
Could we add a cpumap_scnprintf() attribute too, just for consistency?

Bert
