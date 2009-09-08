Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbZIHTe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbZIHTe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZIHTe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:34:58 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:2047 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbZIHTe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:34:58 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: question on sched-rt group allocation cap: sched_rt_runtime_us
Date: Tue, 8 Sep 2009 12:34:55 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501F0F6A8@exchange.ZeugmaSystems.local>
In-Reply-To: <1252436788.6923.14.camel@marge.simson.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: question on sched-rt group allocation cap: sched_rt_runtime_us
Thread-Index: Acowt5cv4q1a326FRuSrtKBP3yRarQAA7rsQ
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <DDFD17CC94A9BD49A82147DDF7D545C54DC48B@exchange.ZeugmaSystems.local> <217247FB-ED91-4A24-B698-71CEEFA58636@anirban.org> <1252436788.6923.14.camel@marge.simson.net>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Mike Galbraith" <efault@gmx.de>, "Anirban Sinha" <ani@anirban.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dario Faggioli" <raistlin@linux.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Maybe.  Short term hack.  My current thoughts on the subject, after
some
>testing, is that the patchlet should just die, and pondering the larger
>solution should happen.

Just curious, what is the larger solution? When everyone adapts using
control-groups? 
