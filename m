Return-Path: <linux-kernel-owner+w=401wt.eu-S1161513AbXBHBeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513AbXBHBeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 20:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161516AbXBHBeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 20:34:13 -0500
Received: from smtp103.sbc.mail.re2.yahoo.com ([68.142.229.102]:44460 "HELO
	smtp103.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161513AbXBHBeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 20:34:13 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 20:34:12 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IkBzCXrCsNi2VPQfVpdDBJDo4MfzOMs2e0yUilwQ5dGMZtCbWhayIg+whbmBJbS9qNewAZtmAce8Ec/O3gErmuTLiy7Mcy2KseAISi0ITowIRJuHZBmcPHLtWfJ3D4ZvVtL1aWK088YF8JST7J+Ir2Vkz8Q93fFkX346zNJUWbk=  ;
X-YMail-OSG: G8knK14VM1lOlBy97snwH1eD58Ya4u2fyvImK0A9ISLBlC0D2kuX6A__hNHs4Un2.5r8n817pTz0eYAPMZcif8PiJyxbJqc7XoDT5Vg5uagfO899j23J9xVy6oa1tgKnQ9R5aXfXDehdRjwcT09FEpgitOs-
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH 3/28] Driver core: convert SPI code to use struct device
Date: Wed, 7 Feb 2007 17:34:09 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071734.09339.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NAK.  This wasn't supposed to go upstream Greg; and it also
conflicts with other pending SPI patches.

- Dave


