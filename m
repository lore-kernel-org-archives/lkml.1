Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbYJWAQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbYJWAQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 20:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbYJWAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 20:16:00 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6961 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYJWAP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 20:15:59 -0400
X-IronPort-AV: E=Sophos;i="4.33,467,1220227200"; 
   d="scan'208";a="180751778"
From: Roland Dreier <rdreier@cisco.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Hang early in boot with 2.6.27-git
References: <adaej28urfi.fsf@cisco.com>
	<86802c440810221703y6d5a3be3ge260014b25be1345@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Oct 2008 17:15:57 -0700
In-Reply-To: <86802c440810221703y6d5a3be3ge260014b25be1345@mail.gmail.com>
	(Yinghai Lu's message of "Wed, 22 Oct 2008 17:03:30 -0700")
Message-ID: <ada63nkupxe.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Oct 2008 00:15:58.0045 (UTC) FILETIME=[85C6D0D0:01C934A4]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > http://lkml.org/lkml/2008/10/21/300

That was it -- thanks very much!
