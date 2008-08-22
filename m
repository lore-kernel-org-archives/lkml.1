Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbYHVA3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbYHVA3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 20:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYHVA2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 20:28:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:42039 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYHVA2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 20:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TV3uHJq7Syi+MCgkG0ziLxUiDuGWmdhRqDRuFuz+yGEETblwz2v5gZV/KJHTZwcOZk
         NwNb1COvyeOCqcDZNBOB1jAw9B4Eu2d6O3mE8Wj75UMzhMI++RH5Qq2/mXKvJNmrqoEp
         uCj5pN7c5VK8K/iyG3mygYlXyTlUaiQ1A9GDM=
Message-ID: <86802c440808211728r4b5a7a37w929c2dd68616361d@mail.gmail.com>
Date: Thu, 21 Aug 2008 17:28:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Joshua Hoblitt" <josh@hoblitt.com>
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of 16gb of memory is usable
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
In-Reply-To: <20080822001047.GF23377@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-11388-27@http.bugzilla.kernel.org/>
	 <20080820180405.7f164450.akpm@linux-foundation.org>
	 <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com>
	 <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com>
	 <20080821205558.GC23377@hoblitt.com>
	 <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
	 <20080821233317.GE23377@hoblitt.com>
	 <20080822001047.GF23377@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 5:10 PM, Joshua Hoblitt <josh@hoblitt.com> wrote:
> The dmesg from the tip kernel is attached and it's at least larger than
> the last builds dmesg.

did you apply my debug patch?
you should get msr print out...

YH
