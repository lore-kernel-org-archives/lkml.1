Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYBQLGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYBQLGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYBQLGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:06:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:20553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYBQLGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=smverh3ju3OHnzBOVFlVsEvGZ6Mdr8orGO+ZgSVCF9/5v2eExIbvL07lTce02i6Z/eQjBE0RpkhvJ41VWoy+aM4Rgzk71xEcwsnC9FtpJ/S4rugdQCsezP3N8W1fC8VNSweKbVFQYd5s5dzuq0CeLTLIP7pVFYrA/6lHQXig7EI=
Date: Sun, 17 Feb 2008 12:00:18 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: uli526x link problem solved, fix not on 2.6.25-rc2
Message-ID: <20080217120018.01e6bc54@Varda>
In-Reply-To: <20080217094225.GA3929@dis.manty.net>
References: <20080217094225.GA3929@dis.manty.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 17 Feb 2008 10:42:25 +0100
Santiago Garcia Mantinan <manty@manty.net> escribió:

> Hi!
> 
> There was a problem that affected all tulip based drivers and which has been
> fixed in most of them, for uli526x the problem remains on 2.6.25-rc2 as the
> fix has not yet been applied.
> 
> A discusion of this bug and the patch to fix it is at
> http://bugzilla.kernel.org/show_bug.cgi?id=5839
> Several people including myself have tested the patch and have stated that
> it works ok.
> 
> I would encourage people with the proper permissions to submit this patch so
> that it ends up on 2.6.25.

 Maybe CCing Jeff Garzik (manteiner) helps on this regard.

> 
> Thanks in advance!
> 
> Regards...
