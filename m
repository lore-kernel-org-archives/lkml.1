Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYDCU6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYDCU6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 16:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbYDCU6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 16:58:07 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:21848 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbYDCU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 16:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=P7aydLWiUMYBkdB+PMWdapWhtFWXH5tZ6qCiBl7CzwsD9NQSb76EtaubaAukXazX3XS6e+N/GmIqpt2+zioFyfy/iHW4l6JGQNWUtQzLVfCO4ifsyMvyGIP/UnZ7hqjjGI0IxzIY1VI1U8K1DWWa3fAyyqraZAEKvJXmAQ+FAQU=
Message-ID: <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
Date: Thu, 3 Apr 2008 16:58:03 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Xavier Bestel" <xavier.bestel@free.fr>
Subject: Re: ASUS ScreenDuo
Cc: "Alan Stern" <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1207251545.24007.3.camel@bip.parateam.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
	 <1207251545.24007.3.camel@bip.parateam.prv>
X-Google-Sender-Auth: 79b55c3f43bbccf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Ah. Apparently it just waits for some driver from the Windows side (no
>  way to insert anything in there).
>  I guess it'll just be another useless piece of electronics at home.

If you have a friend with this device and windows, you might be able to
capture the initialization sequence using usbsnoopy or something similar.
Some devices just need a little proprietary poke before they become a normal
USB device.

-Bob
