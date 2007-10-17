Return-Path: <linux-kernel-owner+w=401wt.eu-S1765950AbXJQJIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765950AbXJQJIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbXJQJIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:08:44 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:32829 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbXJQJIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:08:43 -0400
Message-ID: <4715D119.7000508@free.fr>
Date: Wed, 17 Oct 2007 11:08:41 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Understanding lspci output
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I ran lspci -vvv on a system:
http://linux.kernel.free.fr/halt/lspci.txt

(I used lspci version 2.2.5 in case it matters.)

But I'm having a hard time making sense of the output.

1. How many PCI buses are there in the system?

2. Do any of the PCI buses support 66 MHz operation?

3. Do any of the PCI slots support 64-bit data path?

4. Does the system have a PCI-X bus?

Regards.
