Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYB1JOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYB1JOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYB1JOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:14:30 -0500
Received: from mail2.dei.unipd.it ([147.162.2.112]:44865 "EHLO
	mail.dei.unipd.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664AbYB1JO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:14:28 -0500
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 04:14:28 EST
Message-ID: <20080228095447.d9rvhyxegw8o00gs@mail.dei.unipd.it>
Date: Thu, 28 Feb 2008 09:54:47 +0100
From: bott@dei.unipd.it
To: linux-kernel@vger.kernel.org
Subject: question about initramfs
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.5)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm facing a weird problem with initramfs on TI dm6446. I use  
initramfs to hold the binary the device has to execute, so that I can  
store it a flash memory and boot it with uboot without having to use a  
disk.

My problem is that I can boot images of 2.4M but 2.6M sized images  
hang the boot process and kernel is never booted, it just hangs.

I'm trying to identify where the problem is, whether it is related to  
the bootloader or the build mechanism.

So I'm asking you if there is any limitation in terms of size to  
initramfs. If not, where do you think the problem might reside?

Thanks.

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

