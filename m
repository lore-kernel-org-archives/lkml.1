Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbYLCRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbYLCRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLCRJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:09:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:31101 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYLCRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a7bThdZbL8y93TdQltMYVIRebxjTfu9baj6YnG81vFvYzJvxMDWQ+0QHAQjQaJqNCI
         PHn6Z5xcN3tIVldYM+CW7R8ixwp998FSwDs2EU2S02n4EaqeyO4WXNIIuPcBYaCgL6Nd
         zzb9O4ScxVYg5PcdodJVb9tGFhZyaFJUC643Q=
Subject: Re: Unusually low speeds with ath5k and iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Bob Copeland <me@bobcopeland.com>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wally@theblackmoor.net" <wally@theblackmoor.net>
In-Reply-To: <1228323319.12006.3.camel@rc-desk>
References: <492719ED.5000006@gmail.com>  <1228323319.12006.3.camel@rc-desk>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 19:09:07 +0200
Message-Id: <1228324148.23040.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 08:55 -0800, reinette chatre wrote:
> On Fri, 2008-11-21 at 12:28 -0800, Maxim Levitsky wrote:
> 
> > sorry for cross-posting, but this issue really spans both iwl3945 and ath5k.
> > 
> > I have two laptops (acer 5720, and aspire one) and I see some strange speed issues.
> > 
> > I initially blamed iwl3945, then thought it got fixed, but now I have ath5k, and speeds are low
> > and I suspect that both drivers has bugs regarding to speed.
> 
> We just posted some fixes to iwl3945 rate scaling. Could you please test
> with http://marc.info/?l=linux-wireless&m=122824880823630&w=2 ?
> 
> Thank you
> 
> Reinette
> 
> 
I''l test this, but for all my tests rate on iwl3945 was already 54M,
could this still help?

Best regards,
	Maxim Levitsky

