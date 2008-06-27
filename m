Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYF0Os2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYF0Os2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYF0OsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:48:20 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:22453 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYF0OsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:48:20 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
From: Andi Kleen <andi@firstfloor.org>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-2-git-send-email-joerg.roedel@amd.com>
	<20080627142558.GG18644@cs181140183.pp.htv.fi>
Date: Fri, 27 Jun 2008 16:47:29 +0200
In-Reply-To: <20080627142558.GG18644@cs181140183.pp.htv.fi> (Adrian Bunk's message of "Fri, 27 Jun 2008 17:25:58 +0300")
Message-ID: <878wwrq6im.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jun 2008 14:40:11.0708 (UTC) FILETIME=[B4395FC0:01C8D863]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:
>
> This tells neither what as IOMMU is nor whether my system actually has 
> one.
>
> Please shortly describe in the help text what an IOMMU is and which
> AMD systems have an IOMMU.
>
> The goal is that a system administrator building a kernel for his system 
> gets enough information for deciding whether to enable or disable this 
> option.

Also it should ideally describe that there is a trade off between
reliability and performance with IOMMU enabled.

-Andi
