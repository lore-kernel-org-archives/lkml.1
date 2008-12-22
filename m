Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYLVWKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYLVWKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbYLVVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:53:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:54443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbYLVVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b0vhWj3G8kZZpV5I31TTBZe0cXhQeHzspdYpvfpjjLDhw96TL8H8gwah8sF9BFuFg7
         EbH4PsAOUIUaOwEftyQcLe1ZTkq9/1GLWFSo0VU9WPDAxg6hCsIjv4pIwcq2Vsj04xu9
         zVZvFRstYZ07ItN2dhy0yGD6+SGTTAb5P/Jyc=
Subject: Re: Problem with thermal control: ACPI: Critical trip point -
 Critical temperature reached  - shutting down.
From: Alessandro Bono <alessandro.bono@gmail.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <494E862D.5030309@shaw.ca>
References: <gigib1$fbj$1@ger.gmane.org> <494C8B5B.8020606@shaw.ca>
	 <1229770623.8215.82.camel@champagne.cantina>  <494E862D.5030309@shaw.ca>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 22:53:18 +0100
Message-Id: <1229982798.7690.10.camel@champagne.cantina>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-21 at 12:08 -0600, Robert Hancock wrote:
> Alessandro Bono wrote:
> > On Sat, 2008-12-20 at 00:06 -0600, Robert Hancock wrote:
> > 
[...]

> 
> Looks like the fan entries are being commanded pretty much full out.. 
> (I'm sure those don't all correspond to physical fans, but likely 
> different fan speeds.) Are you sure there's not a hardware problem (one 
> or more fans not working, vents/heatsink clogged with dust)? Your system 
> seems to be running very hot.

Hi Robert

Notebook seems in perfect status and all (one) fans working. Also I
tried latest kernel 2.6.28-rc9-git3 but without changes (operation not
easy considering that machine shutdown in the middle of a compile
process)
I found this on mcelog but it's not dated so I don't know when this log
appear

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 THERMAL EVENT TSC 862841a78
Processor core below trip temperature. Throttling disabled
STATUS 88370100 MCGSTATUS 0


Is this related to thermal problem of my pc?
Is there other test to do? I'm thinking to try the strange OS
preinstalled with this machine to verify if it's an hardware problem but
I want to keep as last (very last) think to do

Thanks for your help

