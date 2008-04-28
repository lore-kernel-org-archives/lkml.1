Return-Path: <linux-kernel-owner+w=401wt.eu-S934734AbYD1OWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734AbYD1OWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933437AbYD1OWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:22:11 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:3122 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbYD1OWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:22:10 -0400
Date: Mon, 28 Apr 2008 16:21:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: i2c or eeprom enumeration problem
Message-ID: <20080428162123.7fd8eb04@hyperion.delvare>
In-Reply-To: <4815DC52.1050908@redhat.com>
References: <4815509A.9040802@redhat.com>
	<20080428050515.fcc05689.akpm@linux-foundation.org>
	<20080428141526.2f4e993f@hyperion.delvare>
	<4815DC52.1050908@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 07:16:50 -0700, Ulrich Drepper wrote:
> Jean Delvare wrote:
> > Motherboard manufacturer and model?
> 
> Tyan S4985.  It's a quad socket, quad core AMD system.

OK. Maybe it uses the same trick as the S4882... Can you get the
information from Tyan?

Please provide the output of i2cdetect for all the SMBus channels.

-- 
Jean Delvare
