Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXAaNhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXAaNhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXAaNhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:37:51 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:7082 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXAaNhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:37:50 -0500
Subject: Re: [PATCH 0/8] readahead updates
From: martin <mp3@de.ibm.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070127080219.161473179@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 14:37:47 +0100
Message-Id: <1170250667.20442.48.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-01-27 at 16:02 +0800, Fengguang Wu wrote:
> Andrew,
> 
> Here are more updates for adaptive readahead.
> 
> It's not likely to have more big changes, so the next plan is to convert some
> accounting items to the statistics infrastructure by Martin Peschke.
> [Martin: Sorry for the long delay.]

Do you mean the ra_account() items?

Thanks,
Martin

