Return-Path: <linux-kernel-owner+w=401wt.eu-S935353AbYCEAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353AbYCEAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbYCEAGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:06:25 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:1756 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbYCEAGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CSxb3xFwVRfLC9BPV66ArLLYCAI8mSaOIlZrZnVjBrxgrnXSqizGCgjLmqT0SicGoax6WS0JfhDMmm1vEGbOOSohV3iAyPszxyWMVm9bLISG7LDGHF8u3eaOVwSQ1LCcDWPbYp3zE+X9Fv97fYwtM71VrbKY8RrhrKZMIGNpskM=
Subject: Re: [PATCH] drivers/base: replace remaining __FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204675494.5698.38.camel@brick>
References: <1204675494.5698.38.camel@brick>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:05:59 -0800
Message-Id: <1204675559.5698.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 16:05 -0800, Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> versus git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-2.6.git
> 

Sorry, this wasn't meant to be sent, please ignore.

Harvey

