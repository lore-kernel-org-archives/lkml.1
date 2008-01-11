Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbYAKCWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbYAKCWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbYAKCWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:22:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:5380 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYAKCWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WSlveex74iezXI6rOgU0BtjcnI8FPmrJYih52YEZyH/nL0lQ94hBxz+z+n0vHEZQiFWokUUsgP5wBJmUIlsPrnGalCkyKXEecUj1jBPdmxcrA0AO78jCwG4RFBFhyor7eCzFgXxEZIJanpiSmUzzCFMCNic+VhwOoYOoHXisueQ=
Message-ID: <b25c3fa70801101822t51abb8djf6cbf269efd49f8@mail.gmail.com>
Date: Fri, 11 Jan 2008 11:22:08 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1200016915.3530.161.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11998765783953-git-send-email-joonwpark81@gmail.com>
	 <1200013607.3530.128.camel@debian.sh.intel.com>
	 <b25c3fa70801101738j512a6189i3e4541bf0348b91f@mail.gmail.com>
	 <1200016915.3530.161.camel@debian.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/11, Zhu Yi <yi.zhu@intel.com>:
>
> The version doesn't work on a .24-rc kernel. Can you compile it
> with .23?
>

Thank you for your help, I built it.

Thanks,
Joonwoo
