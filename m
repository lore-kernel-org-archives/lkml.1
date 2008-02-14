Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYBNVrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYBNVrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYBNVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:47:27 -0500
Received: from emulex.emulex.com ([138.239.112.1]:44261 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYBNVr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:47:26 -0500
Message-ID: <47B4B6D8.6000204@emulex.com>
Date: Thu, 14 Feb 2008 16:47:04 -0500
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make lpfc_disable_node() static
References: <20080214212402.GF23227@cs181133002.pp.htv.fi>
In-Reply-To: <20080214212402.GF23227@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2008 21:47:05.0078 (UTC) FILETIME=[23A0F960:01C86F53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Adrian Bunk wrote:
> This patch makes theneedlessly global lpfc_disable_node() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---

ACK

-- james s

