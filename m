Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbYCLGYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbYCLGYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYCLGYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:24:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:19640 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYCLGYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TIyymED6eYMfOG4aRHXoHyUY5uSKiwWvWchEFsqEry9PXDiesMh56U8OvTcuz6uTU8XUNPG9eiOkgVy+n26qb5cYzQA/1bxo8KfzAq7G2a87gfwF7k7O6ulAFlRZTNLYUw27kYHjAdcmP+uJmBeanHYRSAqce0HjHASehfYBF9I=
Message-ID: <2f9dd5d80803112324x631c1c29yffe8824f18acd2e5@mail.gmail.com>
Date: Wed, 12 Mar 2008 11:54:45 +0530
From: "Prashant Shah" <pshah.mumbai@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [bug] networking, network not detected if lan wire not connected while boot
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using ubuntu gutsy.

Kernel details :

2.6.22-14-generic

Lan card details :

DFE-538TX 10/100 Ethernet Adapter
RTL8139 Ethernet chipset

While booting, if the LAN wire is not connected and I connect it
later, the network does not get activated.

If the LAN wire is connected during the boot process and I remove and
reconnect the wire later on - it works.

ps : sorry i dont know where to report bugs..
