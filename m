Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbZFLOcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbZFLOcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932312AbZFLOcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:32:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51597 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762888AbZFLOcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:32:21 -0400
Subject: Re: TPM drivers support and Linux Integrity Module for 2.6.30
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Shahbaz Khan <shaz.linux@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       tpmdd-devel@lists.sourceforge.net
In-Reply-To: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 10:32:21 -0400
Message-Id: <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 11:59 +0600, Shahbaz Khan wrote:
> Hi,
> 
> I am using Intel Q45 Express chipset with TPM version 1.2 specs of
> TCG. The kernel version is 2.6.30. Problem is that the TPM drivers
> cannot provide functionality to the TCG TSS giving error message:
> 
> "TCSD TDDL ERROR: Could not find a device to open!"
> 
> The device node in /dev is also not being created which should be
> "/dev/tpm". If created manually then still it does not work.
> 
> What should be done?
> 
> Thanks.
> 
> --
> Shaz

This is a device driver issue. Copying the TPM maintainers and the
forum.

Mimi

