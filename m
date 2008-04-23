Return-Path: <linux-kernel-owner+w=401wt.eu-S933998AbYDWBFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbYDWBFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbYDWBFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:05:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:23244 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbYDWBFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=stif1V5m2DE4fXma6bZMscBV5nhD9OaSJ7eLGViLdjMUA/Hl1H6vZmWnw3sA4pH3lm+tew5Qr7k3mx7QDz476VCm5547cR+FdogU5wWXNO9iQOREH2wFsbHuku7zBbKixdr3+TnbrG3h5Jwof8ozO9KBu3xbHdD9bGJsRwHut2A=
Message-ID: <b6a2187b0804221805j38905128h74b6db258301f10f@mail.gmail.com>
Date: Wed, 23 Apr 2008 09:05:39 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
Cc: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
	 <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>
	 <20080422214050.GA1166@jurassic.park.msu.ru>
	 <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 5:59 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  On Wed, 23 Apr 2008, Ivan Kokshaysky wrote:
>  > Yes, exactly. My fault - I somehow missed the cardbus stuff...
>  Ok, this patch looks sane, but ..
>  Patch entirely UNTESTED!

I just tested Linus's patch and it works.

Thanks,
Jeff.
