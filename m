Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbYJCPjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbYJCPjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYJCPjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:39:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:11715 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYJCPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MaKNs1KkDqUpogQ9Y0lwD73xWSgfGTha4pYuAl/8mMVH4vbSOXjEOfKYLyawN5hpr2
         ++rZqv6xn7Z1K1fFLwOkjRCQx5MowrAhPOxgQSAOuelfOrIiaPVEzPJ/7itADtiBeike
         aspMK7FyxlQK6T8QMdGYysroaDrbOv3uXEy88=
Message-ID: <e9c3a7c20810030839n4757574eo1ec7473075c74013@mail.gmail.com>
Date: Fri, 3 Oct 2008 08:39:20 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] dw_dmac: Fix copy/paste bug in tasklet
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>
In-Reply-To: <20081003022638.788307fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222784879-14160-1-git-send-email-haavard.skinnemoen@atmel.com>
	 <20081003022638.788307fd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 2:26 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> We haven't heard from Dan for a week and this still wasn't in his tree
> yesterday.

Sorry for the non-response, I'll continue to be on vacation until the
13th with intermittent access to lkml.

>
> I think I'll cheerily send it in to Linus for 2.6.27.

Acked-by: Dan Williams <dan.j.williams@intel.com>
