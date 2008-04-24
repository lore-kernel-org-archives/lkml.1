Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYDXO1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYDXO1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYDXO0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:26:54 -0400
Received: from mail.syneticon.net ([213.239.212.131]:35374 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYDXO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:26:53 -0400
Message-ID: <481098A4.50107@wpkg.org>
Date: Thu, 24 Apr 2008 16:26:44 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080305)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, jbarnold@MIT.EDU,
       francois.cami@free.fr, Andi Kleen <andi@firstfloor.org>,
       mail@earthworm.de
Subject: Re: A system for rebootless kernel security updates
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Arnold wrote:

> I've put together an automatic system for applying kernel security patches 
> to the Linux kernel without rebooting it, and I wanted to share this 
> system with the community in case others find it useful or interesting.

Hmm, the idea seem to be patented by Microsoft, i.e. this patent from 
December 2002:

http://www.google.com/patents?id=cVyWAAAAEBAJ&dq=hotpatching

(and other patents by Microsoft if you search for "hotpatching").


And those patent descriptions, by the way, remind the way kexec works 
("A software module is hotpatched by loading a patch into memory and 
modifying an instruction in the original module to jump to the patch"), 
which was released much earlier... In essence, they patented kexec ;)


-- 
Tomasz Chmielewski
http://wpkg.org
