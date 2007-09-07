Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXIGOBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXIGOBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965264AbXIGOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:01:28 -0400
Received: from bay0-omc3-s28.bay0.hotmail.com ([65.54.246.228]:43027 "EHLO
	bay0-omc3-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965248AbXIGOB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:01:28 -0400
Message-ID: <BAY103-DAV2FF4FF229CF0C440DCBBBB2C50@phx.gbl>
X-Originating-IP: [85.36.106.214]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Guillaume Chazarain" <guichaz@yahoo.fr>
Cc: <linux-kernel@vger.kernel.org>
References: <BAY103-DAV19AEEDC8DA30835B958052B2C50@phx.gbl> <3d8471ca0709070615o5627161ard506fa8b89b1566e@mail.gmail.com>
Subject: Re: EIP: [<c02d0069>] tcp_rto_min+0x8/0x12 SS:ESP 0068:c03bbd6c
Date: Fri, 7 Sep 2007 16:00:00 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 07 Sep 2007 14:01:27.0551 (UTC) FILETIME=[9578A8F0:01C7F157]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
> Hi, this should be fixed in mainline by
>
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5c127c58ae9bf196d787815b1bd6b0aec5aee816

Thanks everybody.
I was thinking that this fix was included in rc5 (looking at gitweb it
appear
to be)


