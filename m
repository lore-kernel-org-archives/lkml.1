Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYFIPHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYFIPHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbYFIPHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:07:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42928 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYFIPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:07:20 -0400
To: Greg KH <greg@kroah.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5 of 7] block: Block/request layer data integrity support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<5be7c534c9542dc4bab1.1212814538@sermon.lab.mkp.net>
	<20080608042754.GA21251@kroah.com>
Date: Mon, 09 Jun 2008 11:06:49 -0400
In-Reply-To: <20080608042754.GA21251@kroah.com> (Greg KH's message of "Sat\, 7 Jun 2008 21\:27\:54 -0700")
Message-ID: <yq1od6ak5py.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Greg" == Greg KH <greg@kroah.com> writes:

>> + /sys/class/block/<bdev>/integrity/write_generate
>> + /sys/class/block/<bdev>/integrity/read_verify

Greg> All of the sysfs interfaces should be documented in
Greg> Documentation/ABI/ not here, otherwise they will be tough to
Greg> find and figure out how to use :)

Will do.

-- 
Martin K. Petersen	Oracle Linux Engineering

