Return-Path: <linux-kernel-owner+w=401wt.eu-S937087AbXHIGch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937087AbXHIGch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbXHIGc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:32:29 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:29230 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762763AbXHIGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=O9mXaBEZEmIyMH+xXj/z6Dw/GMGr+qWS/rhVkoMdQNiCULYUzwxe7NkHsg1HH9SNY/upSde78vmoGh6f8YXJMQncIzBLtdYXe24HE7s3fUaCmv3NdQIB4wtmcVuZRo3pCRj8fHscdvOZ1qIoyYkzQOnRZPZVYg9m47sTfApJPhs=
Message-ID: <46BAB52A.4080408@gmail.com>
Date: Thu, 09 Aug 2007 08:33:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Tony Luck <tony.luck@intel.com>,
       Roland Dreier <rolandd@cisco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       James Smart <james.smart@emulex.com>, Hansjoerg Lipp <hjlipp@web.de>,
       Jean Delvare <khali@linux-fr.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level> messages
References: <1186535381.11897.29.camel@localhost>
In-Reply-To: <1186535381.11897.29.camel@localhost>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches napsal(a):
> Found these while looking at printk uses.
> 
> Add missing newlines to dev_<level> uses
> Add missing KERN_<level> prefixes to multiline dev_<level>s
> Fixed a wierd->weird spelling typo
> Added a newline to a printk
> 
> Signed-off-by:  Joe Perches <joe@perches.com>


>  drivers/char/isicom.c                  |   10 ++++++--

Acked-by: Jiri Slaby <jirislaby@gmail.com>

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
