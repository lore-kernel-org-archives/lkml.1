Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYHARtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYHARtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYHARtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:49:36 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:17892 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYHARtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding
         :sender;
        b=eNE39HqT8A2ZEYF8v41g7AYyj3oUOlDacT16A7bc1PLKOrsRS59bJf1e4C2S56zIlo
         cEJv26zqNftU82b22HXoeztlCRgc8oFKXXhJEWvsSEIanaImpOT0qf+Fzf50jiAL+6Fz
         UwE+/1ABWtAGpkBw5L5SqsgMaLofzk+hrNg+k=
Subject: Re: [PATCH 10/10] mtd: remove code associated with
	!CONFIG_PPC_MERGE
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Reply-To: jwboyer@linux.vnet.ibm.com
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <1217609060-6381-11-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-3-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-4-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-5-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-6-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-7-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-8-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-9-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-10-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-11-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:49:30 -0400
Message-Id: <1217612970.2328.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 11:44 -0500, Kumar Gala wrote:
> Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
> remove the dead code associated with !CONFIG_PPC_MERGE.
> 
> The mtd maps should be using the OF based mechanism.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

