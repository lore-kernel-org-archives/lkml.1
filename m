Return-Path: <linux-kernel-owner+w=401wt.eu-S964918AbXBLOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918AbXBLOBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbXBLOBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:01:33 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918AbXBLOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:01:33 -0500
Message-ID: <45D07457.9030006@zytor.com>
Date: Mon, 12 Feb 2007 06:06:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading
 by Gujin 1/3
References: <687898.45581.qm@web26907.mail.ukl.yahoo.com> <m17iuny2xg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m17iuny2xg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> With ELF we get a single file format that works on multiple
> architectures and for multiple OS-s, with well understood rules.  This
> allows for a broader audience who can review and maintain the code.
> In addition to the real possibility of multi-architecture or multi-os
> bootloaders.
> 

Well understood MAYBE (although the "virtual" versus "physical" address 
stuff in ELF is clearly misspecified in the extreme), but they are 
clearly not sufficient for presenting a well-defined entry condition. 
So it's not really anywhere near as straightforward as you make it sound.

	-hpa

