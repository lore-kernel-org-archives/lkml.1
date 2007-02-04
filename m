Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXBDTQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXBDTQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbXBDTQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:16:45 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:43459 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXBDTQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OvpYyPLzRMLWSltEEX5XXqbt2uwRyUyx1eZAQiImijABYT7STQ+hfPiMLj5X7t28MPedbS8r8n9lE+MGw/vNzloPCm7VWJrO7FMZjyWyTPQZ3dn+YOJdUoLxEgylPl1ughjGAZNqxGLaHnf7zbRc1GwKI27SJc18ihg1h38XsqU=
Message-ID: <8d158e1f0702041116j5a197e56p7c17fd1a8a1123cb@mail.gmail.com>
Date: Sun, 4 Feb 2007 20:16:43 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>
Subject: Re: More pata_ stuff
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <200702041910.46421.s0348365@sms.ed.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	 <45C619FC.3040804@shaw.ca>
	 <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	 <200702041910.46421.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Alistair John Strachan <s0348365@sms.ed.ac.uk> wrote:

>
> Which for a PIIX4 chipset is what you want. Somewhat confusingly:
>
> CONFIG_PATA_MPIIX=y
> CONFIG_PATA_OLDPIIX=y
>
> Should be "n", I've been told.

What? No, this cant be. CONFIG_PATA_OLDPIIX is supposed to be the
libsata version for the PIIX IDE driver, which is what i want to use.
CONFIG_ATA_PIIX is the old IDE driver, not the pata_ driver, is it?
