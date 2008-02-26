Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbYBZW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbYBZW04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765223AbYBZWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:28276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764737AbYBZWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NlqHkiZZs8v/D+uXLVz3JkgIZflBFZL8X7VKPujuEPOS/EkE69Y/X7/qW9mGtuvEFl6J9EEjXyWqFVg3K3WUEhEHruG2ZsP6VT3eN6TmvUU5FW5P4KVjXkAzc80hyIIZLqZkYmTiBSmEwCUnPCVHMVWJVyikFR2zfPRocz9zVSU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/6] IDE: Coding Style fixes to drivers/ide/pci/it8213.c
Date: Tue, 26 Feb 2008 22:25:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
References: <20080224191842.61694afb@paolo-desktop> <47C301F4.5010409@ru.mvista.com>
In-Reply-To: <47C301F4.5010409@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262225.22653.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008, Sergei Shtylyov wrote:
> Paolo Ciarrocchi wrote:
> 
> > File is now error free, only a few
> > WARNING: line over 80 characters
> > are left.
> 
> > Compile tested.
> 
> > Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
