Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbYGFRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbYGFRxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbYGFRsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:48:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:9964 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761725AbYGFRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UmbK2RdyXPGSgG2ArY/aYU+vtuzGcLF5P05N88d6auLgO36+17NkbuIXu77MAAZzVt
         K3D5nF7FmQWdx9tHB2qqsVzXlwl6pIi6r1TL6Aw3DkZI0BKzQGWuZt3GovWsYjn69z2l
         F2mtqxMLbeJYyhjQjwZssygkWvZRHOGNsiPmA=
Message-ID: <dd18b0c30807061047m60e4e848v40dc1e8f49127bde@mail.gmail.com>
Date: Sun, 6 Jul 2008 17:47:57 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <uBi7uNfg81L.A.D3B.K0LcIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.D3B.K0LcIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 11:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
> Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-21 2:05 (16 days old)
> References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>                  http://marc.info/?t=121416231700010&r=1&w=4
>
>
>

yes;
as an estimate(been busy with another bug), I'm going to say out of
100 reboots this message will
appear 2 times in a row, and then disappear.
regards;

-- 
Justin P. Mattock
