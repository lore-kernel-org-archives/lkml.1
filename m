Return-Path: <linux-kernel-owner+w=401wt.eu-S1762684AbYA3OoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762684AbYA3OoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbYA3OoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:44:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:48420 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbYA3OoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:44:10 -0500
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <A3EAB036-F69D-48DD-8CA9-4EAAE63AE1F5@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <1201689053956-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 1/6] Change RIO function mpc85xx_ to fsl_ .
Date: Wed, 30 Jan 2008 08:43:35 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you post a device tree update as well.

The older patches on the list for the 86xx .dts should NOT put the rio  
node under the soc.  It should be at the same level as PCI.

- k
