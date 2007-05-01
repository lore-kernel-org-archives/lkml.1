Return-Path: <linux-kernel-owner+w=401wt.eu-S1946078AbXEAXxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946078AbXEAXxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946083AbXEAXxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:53:06 -0400
Received: from mill-adnc_internal-206-71-178-18.adnc.com ([206.71.178.18]:39098
	"EHLO storix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1946078AbXEAXxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:53:05 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 19:53:05 EDT
From: Rich Turner <rich@storix.com>
Organization: Storix, Inc.
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: generic modules
Date: Tue, 1 May 2007 16:31:30 -0700
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011631.30740.rich@storix.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

heres hoping that someone will be able to answer my question, as i have 
searched many places and have been unable to find the type of answer i am 
looking for. i did find the short description of the module in the .c file 
for each, but nothing more detailed.

using 2.6.20 kernel
with or without the following modules loaded i am able to utilize the disks on 
my system, therefore what functionality do the following modules provide?

kernel/drivers/ide/ide-generic.ko
kernel/drivers/ide/pci/generic.ko
kernel/drivers/ata/ata_generic.ko
