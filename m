Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYI2Xk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYI2Xk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYI2XkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:40:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:24096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYI2XkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vgaWdpsq2QzJNJu5ksEWHBXt+wUahqhbQpxa4MqmXO+xCA3YN0yUvWF08AZpu3Qx8C
         k+V6C3Hu6eGP06y0WixI7j66LO1WKTIYU46AeFH9uV1ULGO8RTY0XePKtLQD5Gdv6oBC
         DJ781AeY+0vo5pr5d1O1nsdPZ7Xqscpq5AvCU=
Date: Tue, 30 Sep 2008 01:40:05 +0200
From: Karol Lewandowski <lmctlx@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Karol Lewandowski <lmctlx@gmail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a makes special keys on my T21 unusable after resume
Message-ID: <20080929234005.GA2616@localdomain>
References: <20080929221628.GA3082@localdomain> <200809300025.52904.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809300025.52904.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 12:25:52AM +0200, Rafael J. Wysocki wrote:

> Can you see if the patch at
> http://bugzilla.kernel.org/attachment.cgi?id=18044&action=view
> (against current -git) helps?

It doesn't help (and -rc8 doesn't help either).

Thanks.
