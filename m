Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZEWQ7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZEWQ7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZEWQ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:59:24 -0400
Received: from ms.trustica.cz ([82.208.32.68]:54437 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZEWQ7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:59:24 -0400
Message-ID: <4A182B61.5010503@assembler.cz>
Date: Sat, 23 May 2009 18:59:13 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
References: <1242979484.8796.7.camel@localhost.localdomain>	 <4A165F67.3020005@assembler.cz>	 <1242981748.10642.3.camel@localhost.localdomain> <1242984648.16532.3.camel@localhost.localdomain>
In-Reply-To: <1242984648.16532.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yes it works for most CPUs, but for unlucky users we might get complains from 
them - and false alarms.

I'm talking about:

http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/41322.pdf

Errata #319

So far all CPUs have the issue.

Rudolf

