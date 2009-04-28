Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbZD1PMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbZD1PMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761460AbZD1PGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:06:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:43302 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761706AbZD1PGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:06:53 -0400
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <982CAD05-5F4A-4A33-B991-16162CFFE1D8@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20090428144814.GA14926@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] powerpc: minimizing the configuration of linkstation_defconfig
Date: Tue, 28 Apr 2009 09:54:27 -0500
References: <20090424065816.GA15525@ime.usp.br> <Pine.LNX.4.64.0904242158210.8309@axis700.grange> <20090424223355.GB7858@ime.usp.br> <2CE2BC61-1C6B-4D01-870B-BC460730AD79@kernel.crashing.org> <20090428022711.GA30538@ime.usp.br> <F78629F9-59D2-4974-8461-06B7FAC2625D@kernel.crashing.org> <20090428144814.GA14926@ime.usp.br>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28, 2009, at 9:48 AM, Rogério Brito wrote:

> On Apr 28 2009, Kumar Gala wrote:
>> I'm pretty sure we need this for old initrd style ramdisks so I'd  
>> prefer
>> we leave it enabled.
>
> Oh, for oldstyle it is needed. You're right. It is better to keep it  
> in
> the defconfig. Just drop the hunk from the patch that I sent you.

just send a new patch w/this fixed.

- k