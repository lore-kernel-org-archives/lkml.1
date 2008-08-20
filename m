Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYHTTfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYHTTfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYHTTex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:34:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33026 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbYHTTew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:34:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Wed, 20 Aug 2008 21:38:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <200808202106.41058.elendil@planet.nl>
In-Reply-To: <200808202106.41058.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202138.13302.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Frans Pop wrote:
> Not sure who to CC on this one...
> 
> On my new HP 2510p laptop I'm seeing the following error after resume from 
> suspend to RAM:
> 
> <snip>
> CPU1 is up
> ACPI: Waking up from system sleep state S3
> APIC error on CPU1: 00(40)
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> </snip>
> 
> The weird thing is that this only happens on resume. During system boot I 
> can see no APIC related issues.
> 
> Full dmesg from system boot plus a single suspend/resume cycle attached, 
> and also the kernel config.
> 
> I've no idea (yet) whether this is a regression or not.
> Note that I've sent a separate mail for the hci_usb related issues that 
> are shown later in the dmesg output.

Does the box work after that?

Rafael
