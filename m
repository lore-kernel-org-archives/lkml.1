Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYIIRpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYIIRpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYIIRpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:45:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:54585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYIIRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hEtGOVOB7vc7toaElb7mz6uIeIUfPoN8E8saHWsHDc/5Z2PNJ/ZHFsixZkgfGgrwdR
         9uCfIKw9ZJklw0hoqo3LMi+hq70CtWCaMgvZZpAyZLY9YwINP826cXWq7kUstVLCfXE/
         MWDy+zfEYs6eIYeopye1uBWDZYli6yWYAxkBo=
Message-ID: <86802c440809091045h2d4f1776g94355e1b1dd1b29e@mail.gmail.com>
Date: Tue, 9 Sep 2008 10:45:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Yang, Sheng" <sheng.yang@intel.com>
Subject: Re: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Avi Kivity" <avi@qumranet.com>, "Andi Kleen" <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200809091605.42121.sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12209432941440-git-send-email-sheng.yang@intel.com>
	 <1220943294312-git-send-email-sheng.yang@intel.com>
	 <86802c440809090052t2e626ce8h4fda865b8cbce00b@mail.gmail.com>
	 <200809091605.42121.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 1:05 AM, Yang, Sheng <sheng.yang@intel.com> wrote:
>
> Yeah, I've considered that, but seems duplicate for both files? The feature
> detection code is the same. Any way to merge them?
>

just merged intel_64.c into intel.c...

YH
