Return-Path: <linux-kernel-owner+w=401wt.eu-S965915AbXBOMUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965915AbXBOMUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965918AbXBOMUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:20:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:60202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965915AbXBOMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:20:09 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
To: Andi Kleen <ak@suse.de>, "Martin J. Bligh" <mbligh@mbligh.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Christoph Lameter <clameter@sgi.com>, bob.picco@hp.com
Reply-To: 7eggert@gmx.de
Date: Thu, 15 Feb 2007 13:21:04 +0100
References: <7NZO0-6et-1@gated-at.bofh.it> <7Oa6N-5If-3@gated-at.bofh.it> <7Oaq4-6ow-7@gated-at.bofh.it> <7Oaq6-6ow-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HHfbk-0000pw-Uf@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1+vlvMc9c+8/FKGQiIcWPenlmu/SfVC+S5IhGF7ninAdoK0GegxKM2fdwMb4qUrpEeMHaLQqahGw1sljV+5QQw7K82fJ7Ii8pVZ14j+1MIKdg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> wrote:

> Now if it's better to set up a empty node or use a nearby node
> for a memory less cpu can be further discussed. I still think
> I lean towards the later.

Worst case: Only slot 0 is used. Plug your memoryless CPU card into the last
slot before your plug the CPU+mem card into the last-1 slot.
-- 
W.I.N.D.O.W.S.:
 Wireless Intelligent Neohuman Designed for Observation and Worldwide Sabotage
        -- http://www.brunching.com/toys/toy-cyborger.html
Friﬂ, Spammer: 05gZ@zzFMTbf.7eggert.dyndns.org
