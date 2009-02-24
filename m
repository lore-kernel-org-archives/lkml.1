Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbZBXVms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbZBXVms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbZBXVmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:42:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZBXVmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:42:39 -0500
Message-ID: <49A469B5.7060601@zytor.com>
Date: Tue, 24 Feb 2009 13:42:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Jourdan <tjourdan@interfaceconcept.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
       Peter Jones <pjones@redhat.com>
Subject: Re: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
References: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v> <49A462BD.7010205@zytor.com> <49A468E2.4040308@kernel.org>
In-Reply-To: <49A468E2.4040308@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> should be ok for 2.6.29

Got a feel for what the impact of deferring it to .30 would be?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

