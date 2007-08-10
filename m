Return-Path: <linux-kernel-owner+w=401wt.eu-S937948AbXHJNrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937948AbXHJNrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764545AbXHJNq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:46:59 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:50525 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbXHJNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:46:58 -0400
Message-ID: <46BC6C1C.6040301@csr.com>
Date: Fri, 10 Aug 2007 14:46:04 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: sdio: set host bus width
References: <46BC58E8.50300@csr.com>	<46BC59B6.4060301@csr.com> <20070810153532.2c27b47b@poseidon.drzeus.cx>
In-Reply-To: <20070810153532.2c27b47b@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2007 13:46:17.0357 (UTC) FILETIME=[D36313D0:01C7DB54]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Fri, 10 Aug 2007 13:27:34 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> sdio: set host bus width
>>
>> Need to set the bus width used by the host when enabling wide (4 bit)
>> mode.
>>
>> Signed-of-by: David Vrabel <david.vrabel@csr.com>
> 
> Now this is just embarrassing. Thanks for spotting it.

Don't feel too bad.  I didn't spot it until I started looking at all the
data lines with a oscilloscope.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.
