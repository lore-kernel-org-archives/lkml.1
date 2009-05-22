Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZEVIq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZEVIq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZEVIqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:46:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:54724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZEVIqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:46:50 -0400
Subject: Re: [PATCH-tip] x86: hwmon/k8temp.c Add support for AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <4A165F67.3020005@assembler.cz>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
Content-Type: text/plain
Date: Fri, 22 May 2009 14:12:28 +0530
Message-Id: <1242981748.10642.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 10:16 +0200, Rudolf Marek wrote:
> Hi,
> 
> The reason why there is no support is that the both 10h and 11h and all of them 
> have still the errata which tells that measurements is unreliable. Has it changed?
> 

On my 11h laptop I am getting reading from 56-70 degree C and it seems
to correct and reliable to me.

Can you share the problem you faced with 10h and 11h, so that I can
check on my side.

Thanks,
--
JSR

