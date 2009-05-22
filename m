Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZEVIXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZEVIXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZEVIXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:23:35 -0400
Received: from ms.trustica.cz ([82.208.32.68]:50804 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZEVIXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:23:34 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 04:23:33 EDT
Message-ID: <4A165F67.3020005@assembler.cz>
Date: Fri, 22 May 2009 10:16:39 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
References: <1242979484.8796.7.camel@localhost.localdomain>
In-Reply-To: <1242979484.8796.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The reason why there is no support is that the both 10h and 11h and all of them 
have still the errata which tells that measurements is unreliable. Has it changed?

Thanks,

Rudolf
