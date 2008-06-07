Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbYFGWIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbYFGWIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757583AbYFGWIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:08:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39491 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbYFGWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:08:10 -0400
Date: Sun, 8 Jun 2008 00:08:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       thunder7 <thunder7@xs4all.nl>
Subject: Re: [Bug #10816] vt/fbcon: fix background color on line feed
In-Reply-To: <dCRO4tbfLzK.A.vND.B3vSIB@albercik>
Message-ID: <alpine.LNX.1.10.0806080007040.20733@fbirervta.pbzchgretzou.qr>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.vND.B3vSIB@albercik>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-06-07 22:42, Rafael J. Wysocki wrote:
>
>The following bug entry is on the current list of known regressions
>from 2.6.25.  Please verify if it still should be listed.
>
>
>Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10816
>Subject		: vt/fbcon: fix background color on line feed
>Submitter	: thunder7 <thunder7@xs4all.nl>
>Date		: 2008-05-27 19:33 (12 days old)
>References	: http://marc.info/?l=linux-kernel&amp;m=121191733218735&amp;w=4
>Handled-By	: Jan Engelhardt <jengelh@medozas.de>
>Patch		: http://marc.info/?l=linux-kernel&amp;m=121199453010047&amp;w=4
>
is upstream 774533b3e86fa52941c79aa80ab3f0cc511bba7f.
