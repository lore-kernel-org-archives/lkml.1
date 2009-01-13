Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZAMMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZAMMfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZAMMfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:35:43 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:50041 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbZAMMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:35:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoXAIMZbEnVcsfHPGdsb2JhbAAIiQuKfAEBAQE1AbtjhW8
Message-ID: <496C8A98.90309@sundmangroup.com>
Date: Tue, 13 Jan 2009 13:35:36 +0100
From: Matias <linux@sundmangroup.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Intel x86 Dual Core & Linux AMP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Is there a way to boot a normal standard home x86 dual core PC with two 
different Linux Kernels without a hypervisor?
The idea is of course to give the Kernels their own address space and 
their own rootfile systems, the devices would be unique for each kernel etc.

Can this be done with a standard BIOS and GRUB/LILO?

Cheers // Matias

