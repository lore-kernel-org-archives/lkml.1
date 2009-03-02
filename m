Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZCBPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZCBPqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZCBPqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:46:23 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:7079 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZCBPqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:46:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tnRQSlZ1HRHx47OHWOkO1ZSqgAfO83hV+BFeXCAP2aeKrCjkXHXeQsXZWe/36q9rPl
         I+N8ddIHbFYqf1CZw2UD6zOnXGM+pAIK9oAdrdG1WDYiShWJV8r2xhvErmCbV8N+8I6t
         Dauh5bcxHbAPHJ6TZGgMKeexH4eymDZDNDbF4=
MIME-Version: 1.0
In-Reply-To: <20090302153458.GA25965@silver.sucs.org>
References: <20831c740903020539h68f62f2fj1575408d89050d25@mail.gmail.com>
	 <20090302153458.GA25965@silver.sucs.org>
Date: Mon, 2 Mar 2009 17:46:20 +0200
Message-ID: <20831c740903020746t54715cc1re20562835cff6522@mail.gmail.com>
Subject: Re: usb hotplug and hooking
From: Oguz Yarimtepe <comp.ogz@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have hald installed at my platform. It is an embedded
platform. Checking the udev rules now.


>
> I think these days that problem tends to be handled by HAL
> http://www.freedesktop.org/wiki/Software/hal and some software listening
> to HAL events on dbus . If you are using KDE or GNOME both of these have
> tools for automatically running software when devices are detected
> (GNOME uses gnome-volume-manager and I think KDE has media://ioslave).
>
> --
> Sitsofe | http://sucs.org/~sits/
>



-- 
Oðuz Yarýmtepe
www.loopbacking.info
