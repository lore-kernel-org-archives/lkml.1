Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYGSAX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYGSAX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYGSAXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:23:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33450 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGSAXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:23:51 -0400
Message-ID: <48813400.20704@zytor.com>
Date: Fri, 18 Jul 2008 17:23:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC patch 0/2] x86: Add debugfs entry for PAT memtype list
References: <20080718230812.826863000@intel.com>
In-Reply-To: <20080718230812.826863000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:
> Patchset adds a new entry for dumping PAT memtype list under debugfs.
> I am adding a high level arch directory in debugfs to combine any other
> such debug info. Not sure whether this is the 'right' approach or there
> is anything else being planned for this. Hence the tag RFC.

Look good to me; I have added this to x86/pat.

	-hpa
