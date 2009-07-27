Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZG0SRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZG0SRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZG0SRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:17:22 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47609 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZG0SRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ghuNs7Evjinz46ZrqwfZsqe7rHLnhovPo4wTDohuFEG508ys+L6HecM8GRIw78uShP
         2qTiWmf+geP2WFivySUdvqn5/a5IYk9GrQSrX1Sh3w8HQGEPhUTGttX0p2vizqMZ09dd
         o8vVh4vD0uslv3q1phmTyjtGLb3SgS/lhZWrk=
MIME-Version: 1.0
In-Reply-To: <689eb3470907271102i904d81em6317302e373e0730@mail.gmail.com>
References: <689eb3470907271102i904d81em6317302e373e0730@mail.gmail.com>
Date: Mon, 27 Jul 2009 11:17:20 -0700
Message-ID: <689eb3470907271117x4638464p72964819a80637c0@mail.gmail.com>
Subject: Undefined symbol "min_low_pfn"
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see min_low_pfn as an exported symbol so I am trying to print it
from a kernel module (also of GPL license), but I am getting a
undefined reference.
I want to know what pages (page frame numbers) are used by kernel
code/data/bss etc. min_low_pfn would have told me the lowest usable
pfn.
Is there another way of getting this information? Or printing the min_low_pfn?

--
Thanks,
Anupama Chandwani
