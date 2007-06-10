Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXFJUCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXFJUCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXFJUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:02:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23091 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXFJUCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DYEJwiZS1dZefXI2kwO/lhlUiIyhxVwoAXMlVaaXXv4q0/LdY4CMO8ih+nvVmc01yG5t/9w2HqNT9h9cfdO3d7S9GRVyHakcnprClfADf8UChwFKILLiXezSzZ/xf6W3ymXDWdp5BkEjflj/Sd6p5+C+K9QBRglId9LV9n1M6UU=
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
From: Richard Hughes <hughsient@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Richard Purdie <rpurdie@openedhand.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
In-Reply-To: <20070610101155.GA25070@elf.ucw.cz>
References: <1180710270.3782.5.camel@localhost.localdomain>
	 <1180712592.6390.139.camel@localhost.localdomain>
	 <1180713579.12843.8.camel@localhost.localdomain>
	 <1180715004.6390.169.camel@localhost.localdomain>
	 <20070608185710.GB14372@kroah.com>  <20070610101155.GA25070@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 21:02:16 +0100
Message-Id: <1181505736.5241.1.camel@work>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 12:11 +0200, Pavel Machek wrote:
> Can we keep the original naming? spitz:disk is as unique as led02, and
> it is _way_ easier to use.
> Come on, I want to use the led subsystem from the scripts... 

I don't see a problem with spitz_disk, which is just as easy to use in
scripts.

Richard.


