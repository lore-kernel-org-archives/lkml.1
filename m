Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYE0PjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYE0PjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYE0PjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:39:06 -0400
Received: from www.tglx.de ([62.245.132.106]:51529 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbYE0PjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:39:04 -0400
Date: Tue, 27 May 2008 17:38:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: Remove unused variables in ktime_divns()
In-Reply-To: <20080522222511.GA30893@Pilar.ictp.trieste.it>
Message-ID: <alpine.LFD.1.10.0805271738390.3295@apollo.tec.linutronix.de>
References: <20080522222511.GA30893@Pilar.ictp.trieste.it>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Carlos R. Mafra wrote:
 
> The variables dns and inc are not used, remove them.

Applied. Thanks,

	 tglx
