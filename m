Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYKQMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYKQMN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYKQMNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:13:46 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:50787 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbYKQMNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:13:44 -0500
From: "=?ISO-8859-15?Q?Manfred_Preu=DFig?=" <PreussigM@web.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 17 Nov 2008 13:13:59 +0100
MIME-Version: 1.0
Subject: Just a small question on new kernels
Message-ID: <49216E17.32742.2039A2@PreussigM.web.de>
X-mailer: Pegasus Mail for Windows (4.41, DE v4.41 R1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Provags-ID: V01U2FsdGVkX19slE2gN7Mgm77C++we5ma/cUBcbK5SKTKSoZng
	djxeEEg0E9ZWX5Cz3Wgg4eilNNUpYv3SUSDnDmzZsxhbQJndqe
	WNPBHZgZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
since I haven't a subscription yet for the list please send all 
answers to me in addition. 

I only want to know one thing: Is there any plan to 'let the older 
ide driver die' in kernel or have they done it at all yet? I use an 
ide disk with more than 15 partitions due to historic reasons and 
don't want to change this. With the kernel I use at the moment I can 
add a kernel param (hwprobe=-modules.pata) to prevent the newer 
driver from handling the disk and so it works but what's about newer 
kernels and what is planned for the future?

many thanks for any answer (or a link to an answer I overlooked in 
archive or FAQ)

Manfred Preussig 
