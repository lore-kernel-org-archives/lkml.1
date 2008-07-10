Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYGJFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYGJFi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 01:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYGJFiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 01:38:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:15041 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYGJFiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 01:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jmuXjhVKkAA8EKDFQG4lW69/UhfHNU851BcvO/dDQHsXAEamW46ufXRpIq6wsrmbin
         9tBeUIbUSjdQzmMfdJbkGIx0zGMw8vhIVfTehq280uly2rdKh4nhA8mp8criUCtTpDr8
         6URAOClyTTaQCdzPIyieD3qhrOT070sWluFbw=
Message-ID: <a4423d670807092238g336ae7fdk1e72dfa578398892@mail.gmail.com>
Date: Thu, 10 Jul 2008 09:38:17 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc: host can not shutdown: ata problem
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, linux-acpi@vger.kernel.org
In-Reply-To: <20080709182852.c22ca65a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670807031443v73def4d2g97c9d6acc4b4e941@mail.gmail.com>
	 <200807052213.02098.rjw@sisk.pl>
	 <20080709182852.c22ca65a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/10 Andrew Morton <akpm@linux-foundation.org>:
> Alexander, is this a regression?  Was 2.6.25 OK?
Yes, it is a regression, 2.6.25 worked better.
