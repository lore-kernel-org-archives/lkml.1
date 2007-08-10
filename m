Return-Path: <linux-kernel-owner+w=401wt.eu-S1765322AbXHJNB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765322AbXHJNB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXHJNBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:01:50 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:45651 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXHJNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:01:49 -0400
Message-ID: <46BC617F.9060105@csr.com>
Date: Fri, 10 Aug 2007 14:00:47 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: sdio: add <linux/mmc/sdio_csr.h> for CSR specific CCCR	registers
References: <46BC58E8.50300@csr.com>  <46BC59E2.9060102@csr.com> <1186750740.20129.208.camel@violet>
In-Reply-To: <1186750740.20129.208.camel@violet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2007 13:01:00.0628 (UTC) FILETIME=[80172140:01C7DB4E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi David,
> 
> are these CSR extensions specific to Bluetooth or do they also apply to
> your WiFi and Ultra-Wideband products? If they are Bluetooth specific,
> we might simply keep them inside the Bluetooth SDIO driver.

They're registers common to all chips from BlueCore 6 and upwards. This
includes future non-BlueCore/bluetooth products (but not UniFi-1 or
UniFi-2).

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
