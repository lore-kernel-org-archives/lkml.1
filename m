Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234Ab0AJUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0AJUN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662Ab0AJUNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:13:25 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64930 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0AJUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=huyK2OanAJspdfG3LYPbSzD6KY3LS/Q2dtpYFU70B1UN/F7NWD+iWfFiWFIwbPcsh0
         Nu9++/t/AsaPKqA/FM3IeC8IhVxvtcNywjcEO1f/F+dnJufUn0l9AiMvhinakwbSYIra
         RytVw118Xc92d2i2axB7qxiYTt/W4oAAw+AQw=
MIME-Version: 1.0
In-Reply-To: <201001101933.39683.rjw@sisk.pl>
References: <4B26349D.1080904@netone.com.tr>
	 <8db1092f1001100620w59edea0ah5e7244e11930a005@mail.gmail.com>
	 <201001101933.39683.rjw@sisk.pl>
Date: Sun, 10 Jan 2010 21:13:22 +0100
Message-ID: <8db1092f1001101213i7bdcfd97oa3c2371c334e86c7@mail.gmail.com>
Subject: Re: [BUG] Linux-2.6.32-git10 drm_i915 error
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tarkan Erimer <tarkane@netone.com.tr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/10 Rafael J. Wysocki <rjw@sisk.pl>:

>
> http://bugzilla.kernel.org/show_bug.cgi?id=15026 perhaps?

Yes, at now Linux works fine. No problems after resume from suspend (disk/ram).

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
