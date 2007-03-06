Return-Path: <linux-kernel-owner+w=401wt.eu-S1750785AbXCFUuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785AbXCFUuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbXCFUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:50:07 -0500
Received: from main.gmane.org ([80.91.229.2]:44070 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbXCFUuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:50:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: Tue, 06 Mar 2007 15:07:44 -0500
Message-ID: <jwvabyq6sqq.fsf-monnier+gmane.linux.kernel@gnu.org>
References: <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org> <20070302141840.GA3441@srcf.ucam.org> <20070302220454.a0c66d04.khali@linux-fr.org> <20070302211251.GA10035@srcf.ucam.org> <20070303105316.d51e032d.khali@linux-fr.org> <20070305222548.GA4946@ucw.cz> <20070306162634.bcaaf0c7.khali@linux-fr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: bas1-montreal42-1242353373.dsl.bell.ca
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
Cancel-Lock: sha1:kvtFC7LPYWadN+AtAp22pJ22KcA=
Cc: linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Is there anything preventing us from doing such a walk and pre-allocate
>> > all the I/O ranges? I am not familiar with the ACPI code at all, would
>> > you possibly propose a patch doing that?
>> 
>> ACPI AML is probably turing-complete: I'm afraid you are trying to
>> solve the halting problem (-> impossible).

> Can you please translate this into something mere humans like myself
> have a chance to understand?

Try wikipedia "Halting problem".


        Stefan

