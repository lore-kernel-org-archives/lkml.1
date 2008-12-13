Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYLMJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYLMJqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYLMJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:46:40 -0500
Received: from mail.work.de ([212.12.32.20]:47737 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYLMJqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:46:40 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 04:46:39 EST
Message-ID: <49438190.4060405@gmail.com>
Date: Sat, 13 Dec 2008 13:34:08 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: MSI messages
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering how to handle this:

Does the kernel somehow handle MSI message readback from the PCI config space 
for the MSI message as described in 6.8.1 of the PCI Bus specification 2.3 or 
does a device specific driver have to read the Message Address and Data ?

To put it short: i am wondering how i should read the MSI messages.

Thanks,
Manu

