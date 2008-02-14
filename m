Return-Path: <linux-kernel-owner+w=401wt.eu-S1764303AbYBNSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764303AbYBNSbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763114AbYBNSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:31:08 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43501 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbYBNSbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:31:06 -0500
Message-ID: <47B488D3.1030801@cs.wisc.edu>
Date: Thu, 14 Feb 2008 12:30:43 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] scsi_transport_iscsi.c: make 2 functions static
References: <20080213213017.GA3383@cs181133002.pp.htv.fi>
In-Reply-To: <20080213213017.GA3383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - __iscsi_unblock_session()
> - iscsi_session_state_name()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Looks good. Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
