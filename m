Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbXJALNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbXJALNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 07:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXJALNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 07:13:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49122 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXJALN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 07:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X7SWOiJX/8GR+pZcht0zzxHQurOWVQh39gqTTlK+6p/DgS5TYsprdZGnUzu6OPl39oGrMflZqilZ21vcIQ/KzTNClcCf3ovOxvV1qiOf/HiC2yextPRw04r3oxvD0vOkds5wy0oZflXglZ+6Sl0n+UQZOSKXk0l1wbS8qvkFay8=
Message-ID: <4700D655.8020107@gmail.com>
Date: Mon, 01 Oct 2007 13:13:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Miguel <mc354@tid.es>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: software unplug and plug USB
References: <46FCF0F5.9030004@wpkg.org> <1191224165.6014.12.camel@McM> <4700A44C.2010700@wpkg.org> <1191226692.6014.16.camel@McM> <4700C649.90300@wpkg.org> <1191235568.6014.58.camel@McM>
In-Reply-To: <1191235568.6014.58.camel@McM>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 12:46 PM, Miguel wrote:
> if I remove ehci_hcd / uhci_hcd / ohci_hcd , some other devices like
> touchscreen, GPS and keyboard could stop working.
> 
> backup_modules doesn't matter here, is my personal backup. I have tried
> also to recompile some modules because some times my modem huaweis is
> recognized like usb mass storage.
> 
> I will try a how to guide to do what oliver commented
> 
> "You can use the bind & unbind attributes in sysfs"
> 
> where can i find information about that?

gee, here:
http://lkml.org/lkml/2007/5/28/193
