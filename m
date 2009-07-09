Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483AbZGILh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbZGILh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZGILhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:37:15 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:52534 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZGILhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:37:15 -0400
Message-ID: <4A55D60F.4060703@free.fr>
Date: Thu, 09 Jul 2009 13:35:43 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: peter meng <mengsanshui@yahoo.com.cn>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ask a question related Assemble and C revert  within vmlinux
 ?
References: <789976.67811.qm@web15703.mail.cnb.yahoo.com>
In-Reply-To: <789976.67811.qm@web15703.mail.cnb.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peter meng a écrit :
> Hi
> 
> I compile the linux kernel with mips .
> Is there any tools let the Assemble code correspond to C code ?
> I mean Assemble line correspond to C line .

Look up you C compiler's command line options. There should be several to 
generate listings, with either assembly or mixed assembly and C.

Or if your tool chain has the objdump utility, objdump also has options to 
disassemble, and possibly intermix source code lines.

Amicalement,
-- 
Albert.
