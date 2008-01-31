Return-Path: <linux-kernel-owner+w=401wt.eu-S1765402AbYAaUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765402AbYAaUGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbYAaUGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:06:16 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44161 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbYAaUGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:06:15 -0500
Message-ID: <47A229EC.50204@cs.wisc.edu>
Date: Thu, 31 Jan 2008 14:05:00 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Olaf Kirch <olaf.kirch@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make __iscsi_complete_pdu() static
References: <20080128221127.GX8767@does.not.exist>
In-Reply-To: <20080128221127.GX8767@does.not.exist>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> __iscsi_complete_pdu() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Looks good. Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
