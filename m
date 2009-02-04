Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbZBDLWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbZBDLWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZBDLVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:21:50 -0500
Received: from ozlabs.org ([203.10.76.45]:42112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZBDLVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:21:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: [PATCH 4/7] Ksplice: Add module_data_address (the analogue of module_text_address)
Date: Wed, 4 Feb 2009 21:51:34 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@mit.edu>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-4-git-send-email-jbarnold@mit.edu> <1228521840-3886-5-git-send-email-jbarnold@mit.edu>
In-Reply-To: <1228521840-3886-5-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042151.35977.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 10:33:57 Jeff Arnold wrote:
> From: Tim Abbott <tabbott@mit.edu>
> 
> Ksplice's run-pre matching process needs to be able to determine the module
> that contains a particular text or data address.

Does this mean you really want module_data_address, or you actually want
a module_address()?

Thanks,
Rusty.
