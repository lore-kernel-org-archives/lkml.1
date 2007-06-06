Return-Path: <linux-kernel-owner+w=401wt.eu-S933983AbXFFD1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbXFFD1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 23:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXFFD1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 23:27:34 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:14508 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXFFD1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 23:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RoiXmEL7elj9yenjI1RldRJ20ZOwQgKaSSYwDD4t/4u8TCmqu3oLkgMAPzOTlmujNXjWAUDZbRadCKdftlGnyQlwMblJ2Bmo8m4xeVBmSd/Of3frE+xfjNXqgO4S/ddBb8gDMT/O4+NfZIH9uDhMv4VWoWV0qDD9pMebqpm/08Q=
Message-ID: <a8e1da0706052027j25664598tda9b370998e1828@mail.gmail.com>
Date: Wed, 6 Jun 2007 03:27:31 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc bug
Cc: "clameter@sgi.com" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Jiri Kosina" <jkosina@suse.cz>
In-Reply-To: <20070605194236.03e07a1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
	 <20070605194236.03e07a1f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> Are you able to reproduce this in 2.6.22-rc4?

The bug seems doesn't exist in 2.6.22-rc4, I have tested it, the
unpluging can't produce kernel bug message.

Regards
dave
