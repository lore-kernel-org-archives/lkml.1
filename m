Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYHULa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYHULa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbYHULar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:30:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36545 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145AbYHULaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:30:46 -0400
Date: Thu, 21 Aug 2008 12:30:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Message-ID: <20080821113042.GA3796@srcf.ucam.org>
References: <200808202106.41058.elendil@planet.nl> <200808202138.13302.rjw@sisk.pl> <200808202226.45655.elendil@planet.nl> <200808202356.33036.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808202356.33036.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 11:56:32PM +0200, Rafael J. Wysocki wrote:

> On my box I see many "APIC error on CPU1: 00(40)" messages that don't seem
> to be related to anything obviously bad and I've alwas been seeing them.

This is on the 6325? I'd always assumed they were due to the broken 
timer setup.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
