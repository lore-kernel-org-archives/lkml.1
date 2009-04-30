Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZD3TQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZD3TQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZD3TQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:16:06 -0400
Received: from blaine.gmane.org ([80.91.229.8]:51551 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZD3TQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:16:04 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: reinette chatre 
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>
Cc: Andreas Schwab 
	<public-schwab-Td1EMuHUCqxL1ZNQvxDV9g@hugh.gmane.org>,
       "linux-wireless-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "linux-kernel-u79uwXL29TY76Z2rM5mHXA\@public.gmane.org" 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
References: <m24ow6vah1.fsf@igel.home> <1241112119.10498.11.camel@rc-desk>
	<m24ow6xd9y.fsf@igel.home> <1241116390.10498.50.camel@rc-desk>
X-Yow: ..Wait 'til those  ITALIAN TEENAGERS get back to their HONDAS &
 discover them to be FILLED to the BRIM with MAZOLA!!
Date: Thu, 30 Apr 2009 20:33:23 +0200
In-Reply-To: <1241116390.10498.50.camel@rc-desk> (reinette chatre's message of
	"Thu, 30 Apr 2009 11:33:10 -0700")
Message-ID: <m2zldyvvnw.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



reinette chatre
<reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> Thanks. Even though this patch obsoletes
> 6269b731560d69c5eaa929909891edec39496d71 it still makes sense to have
> that patch in the repo as it removes another unnecessary EXPORT_SYMBOL.
> I would thus prefer that both patches are included.

I agree.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

