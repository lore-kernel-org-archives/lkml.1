Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZCQVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZCQVUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZCQVU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:20:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZCQVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:20:26 -0400
Message-ID: <49C013E2.3090704@kernel.org>
Date: Tue, 17 Mar 2009 14:19:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com> <49BEBD98.3090905@goop.org> <49BEC143.6030104@zytor.com> <49BEC53F.20200@goop.org> <49BED431.5070201@zytor.com> <49BF0A51.5000909@kernel.org> <49BF2054.9020009@zytor.com> <49BF301C.6010708@goop.org> <49BFCA05.7000508@zytor.com> <49BFFD3C.3020908@goop.org> <49BFFDE4.1070601@zytor.com> <49C0012A.6060903@goop.org>
In-Reply-To: <49C0012A.6060903@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can you check __brk_limit in extend_brk() ?

YH
