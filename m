Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYFIT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYFIT3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYFIT3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:29:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:41666 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYFIT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gf4z/2RRzI/WmhQ4T8QdXza9LyPc2FeHxOSbnPMh0wfUGu1UcI7qO5WmQj2NoD7OlO
         8Oi4tMPoUAketHid4/iqP8zbNHCp2IOXUEF54j/udNxIQY3VnIS8ef0a/sBZkX0ogW4B
         6kyrnhNLAA3qO0krclnFVnRFUpD27S8f9Qqrk=
Message-ID: <e2e108260806091203v6685d31duf057a3f9744fe7d4@mail.gmail.com>
Date: Mon, 9 Jun 2008 21:03:42 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Stefan Hellermann" <stefan@the2masters.de>
Subject: Re: GPIO-Ports on VIA EPIA-SN
Cc: linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>
In-Reply-To: <1213034405.2592.22.camel@hel-stefan.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213034405.2592.22.camel@hel-stefan.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 8:00 PM, Stefan Hellermann <stefan@the2masters.de> wrote:
> I have a VIA Epia-SN embedded-board with 8 GPIO-connectors. I got the
> attached documentation from VIA after I asked how to use the
> GPIO-connectors with Linux.

Are you already familiar with the LDD book
(http://lwn.net/Kernel/LDD3/ +
http://lwn.net/Articles/2.6-kernel-api/) ? That book is a good
starting point, together with the file Documentation/gpio.txt in the
Linux kernel tree.

Bart.
