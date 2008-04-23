Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbYDWBrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbYDWBrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbYDWBrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:47:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:24190 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787AbYDWBrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QsRywQ8MxBLyOOn93NM0zRckzu+S9QcCzTVDLskoERjzfgw3YqBytt/xUiN/bmJxeBDgID99x1sc50nn8hyfaY35YPo7ZS81MO4oC4+DJnOAodXSnUnjIMKQpVuxFzww9fTBaiiPRcTe7qT4I7K3N6LX4DVRz8ogHG2F1qY1eCQ=
Message-ID: <b6a2187b0804221846g36ea8fc8kce947e9f80476c5f@mail.gmail.com>
Date: Wed, 23 Apr 2008 09:46:53 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Broken] PCI: clean up resource alignment management
Cc: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804221822340.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0804220943l26f7b441sb5a7309dff0e84dc@mail.gmail.com>
	 <alpine.LFD.1.10.0804221020470.2779@woody.linux-foundation.org>
	 <20080422214050.GA1166@jurassic.park.msu.ru>
	 <alpine.LFD.1.10.0804221451270.2779@woody.linux-foundation.org>
	 <b6a2187b0804221805j38905128h74b6db258301f10f@mail.gmail.com>
	 <alpine.LFD.1.10.0804221822340.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 9:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>  Thanks, and I could test it myself (without any actual card, but at least
>  I could see the failure to even set up the bridge, and the fix).
>
>  So I committed it.

Cool. Thank you.  And the patch does works. I'm using the wireless modem now.

Jeff.
