Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbZJEHDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbZJEHDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZJEHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:03:10 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:63817 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbZJEHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UdRR9VW3UfjF8+evgd1lRnd67LgmdBNusyWs6MFB8qJZN73zVMVTPeVCt7aT1XLjx2
         QPPlRp/WQyTA+JgcWptzGBuJOVXFnhBZ0iDDL35j5KOAFBBw9yhth9Npl5WMAKaTd7+C
         Og9p63OIzoYYbs5MoT/X90BRzCzFDsPA2KHwI=
Date: Mon, 5 Oct 2009 09:01:57 +0200
From: Johan Hovold <jhovold@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091005070157.GA16267@localhost>
References: <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
 <20091002084755.GA7382@localhost>
 <20091002173308.6158d734@lxorguk.ukuu.org.uk>
 <20091003114229.GB605@localhost>
 <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
 <20091003140522.GA8725@localhost>
 <20091003173324.315855ac@lxorguk.ukuu.org.uk>
 <20091004194822.GD24079@localhost>
 <m1d452wwyd.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d452wwyd.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 04, 2009 at 04:39:22PM -0700, Eric W. Biederman wrote:
> To test this what should I be applying this on top of?
> There have been a lot of patches flying around.

Only my initial removal of low_latency patch.

Thanks,
Johan

