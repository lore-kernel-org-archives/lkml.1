Return-Path: <linux-kernel-owner+w=401wt.eu-S936672AbYD1UA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936672AbYD1UA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765616AbYD1UAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:00:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765474AbYD1UAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jTy2/5dascUiFJZNzsRVNbHF8E2lOIDW1xR+B4BuHQ34JyGZ81K3u0lUo1+SXwoy9thXj+Y8Wpht1zoMDkUJTujr5DsocOFQRUkQuJ4BOsUQZ3OcF1QNE1bI0R9kH4ijKJUGK6edt0WQ0t+rBq/UljiQosrYOetshDbUtOfTBHg=
Message-ID: <aa79d98a0804281300r49097a51l7093375bcd47004a@mail.gmail.com>
Date: Tue, 29 Apr 2008 00:00:09 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Markus Metzger" <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4816299B.5040002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080428191504.GA6842@cvg> <4816299B.5040002@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, my fault, i had to be more concrete :(
