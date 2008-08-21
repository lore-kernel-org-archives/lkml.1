Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYHUOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYHUOMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYHUOMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:12:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:63495 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYHUOMB (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ilTTGJ5YsYt/7reR96jTElRa133U4eaVZEfZZTgl8PqTblYL+VM2UX+eyFtQx9ZdPV
         j4Kdp35/kGWzBVlm5ZAc9Eoxcv4+DhS1Xn/fSdKNgR4MOqr54arW/CkCSc/z5PaazkyD
         hfJytEMAEKD643RNbUZx/LcmCAg1kZNIOzXF4=
Message-ID: <6934efce0808210712u36144c78mb7f1998414a549cf@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:12:00 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com
In-Reply-To: <200808211453.26233.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <48AD42AE.4030107@de.ibm.com>
	 <200808212043.51209.nickpiggin@yahoo.com.au>
	 <200808211453.26233.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One thing that would be really nice is if you could add fake-write
> support in the way that I proposed for cramfs a few months ago.
> This would make axfs much more interesting for another set of
> users, and keep cramfs a really simple example file system.

Did that get merged?
