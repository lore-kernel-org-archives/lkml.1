Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXHCO36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXHCO36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbXHCO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:29:52 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:44682 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762166AbXHCO3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:29:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend =?iso-8859-1?q?by=09default_on_certain_device?= classes
Date: Fri, 3 Aug 2007 16:32:07 +0200
User-Agent: KMail/1.9.7
Cc: Dave Jones <davej@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <200708030957.46320.oliver@neukum.org> <20070803142416.GB11942@redhat.com>
In-Reply-To: <20070803142416.GB11942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708031632.07979.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 03 August 2007 schrieb Dave Jones:
> On Fri, Aug 03, 2007 at 09:57:45AM +0200, Oliver Neukum wrote:
>  
>  > Kernel developers are a diverser lot than you think ;-)
>  > We don't enable autosuspend in drivers we can't test, except where
>  > the lack of a kernel driver forces us to use a broad swipe. Printers
>  > were tested, too, and most printers seem to work.
> 
> My experience suggests the opposite.  Of the several I've tried so far,
> none have worked with usb suspend.

vendor:product please.

In addition, I'll make a config option for usblp using autosuspend.

	Regards
		Oliver
