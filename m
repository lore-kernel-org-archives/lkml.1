Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZD3CNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZD3CNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZD3CNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:47894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZD3CNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:13:34 -0400
Message-ID: <49F90941.2030405@kernel.org>
Date: Thu, 30 Apr 2009 11:13:21 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu> <49F043A4.2060700@kernel.org> <E1LypSa-0004fR-J1@pomaz-ex.szeredi.hu> <49F908A1.70207@kernel.org>
In-Reply-To: <49F908A1.70207@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 02:13:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> I'll post the updated libfuse patch as well.  Please let me know if
>> you find anything wrong with the current patches.
> 
> Looks good to me.  Much prettier with two inits merged.

Oh... what happened to CUSE_INIT_DONE?

-- 
tejun
