Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXFRVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXFRVZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbXFRVZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:25:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:23530 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761247AbXFRVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Yp48A67S54fmMz9AjO4VGGkhdGqLPBEqqOwJ1j/tF/ZxNsBYNYZPMmZ03v4Obgqg95mk206DDFm3C99U94sMLdSXSnrk62USMO3uk8xzJQxMRINfxlR0XKM2n8k/fvV+OzbGJC2VtwLJfbh91aofC0rsL204FyOSCa9L7JMUEFE=
To: linux-kernel@vger.kernel.org
Subject: GPLv3 dispute solution - new open source license?
Date: Mon, 18 Jun 2007 17:25:01 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181725.01584.yurimxpxman@gmail.com>
From: Joshua David Williams <yurimxpxman.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been keeping tabs on the GPLv3 dispute for quite some time. It seems to 
me that the best solution would be for us to write our own open source 
license - one that would be written specifically to uphold the ten rights in 
the open source definition.

I'm not a lawyer, and this is fairly rough, but below is my attempt at an 
initial draft. It largely resembles the GPLv2, though it differs in several 
key points. I like to refer to the idea as Copyup, because the license gives 
the users extended rights of modification, but does not as go to the extent 
the GPL does to uphold ethical freedoms, so we're sitting 90 degrees between 
the two extremes ;-)

Open Source License
Version 0.1, June 2007

Copyright (C) Joshua David Williams 2007. Everyone is permitted to distribute 
this document, but modification is strictly prohibited.

Preamble

In contrast to the GNU General Public License, this document does not limit 
the use of a program by any means, regardless of ethics and freedom. This 
license grants you, the user, full permission to copy, modify, and distribute 
this software.

1. This license applies to any program which contains a notice by the 
copyright owner that the information may be distributed under the Open Source 
License. This document describes the terms and conditions of the distribution 
of the program's source code and binary executables, but does not apply to 
the usage of said program, including intellectual property created by the 
program. This license also applies to the distribution of any modifications 
made to the program.

This license is not restricted to any form of distribution, including, but not 
limited to, certain products. The terms and conditions described in this 
license must be upheld under every circumstance. The program may be 
distributed by any means, alongside any other programs, regardless of their 
license.

By "program", we mean any type of data, regardless of format, which performs a 
defined set of actions on any type of computer system. The term "binary 
executable" refers to the data the computer system executes, which is 
typically stored in the binary numeral system. We refer to the term "source 
code" as the preferred means of modifying said program, which is the original 
document written by the author of the program before it was compiled as a 
binary executable.

Hereinafter, each licensee will be addressed as "you", and the copyrighted 
information in question will be referred to as "the program".

2. You may distribution copies of the program freely, with or without a fee, 
under the terms and conditions of this license, provided access to the source 
code is not provided only at an additional cost. The distribution of the 
source code alongside the binary executables is not necessary, but you must 
maintain full notices that the program is licensed under this document, in 
addition to information regarding obtaining the source code.

The source code must be made available at a small or no additional fee, 
provided that the user obtained the binary executables legally. This includes 
the payment of a fee in order to obtain the program. This license does not, 
however, require that you charge a fee for the distribution of the program.

3. This license hereby grants you permission to modify the program and 
distribute the results in any means desired, under the condition that this 
document is distributed alongside the modified program, and that no terms of 
this license are broken. This includes, but is not limited to, modifying the 
original source code to extend the program's functionality.

Distribution of the modified program must be clearly defined as such; the 
original author can not be held responsible for changes made by others. The 
original author may require that modified copies be renamed in order to 
uphold his or her integrity. Modifications are subject to this license 
agreement, and fees are not required for the distribution of the program or 
its modifications, but they are permitted.

4. Distribution of the program may not be restricted to any set of persons or 
groups of endeavor. Discrimination of any kind is not permitted by this 
license for any reason whatsoever. Any program released under this license 
may be distributed with or without a fee to anyone, regardless of sex, skin 
color, religious or political affiliations, or ethnic background.

5. This program may be distributed alongside other programs of any other 
license. This license may or may not apply to each individual program this 
program is distributed with. However, this license does not permit 
discrimination against the distribution of this program alongside other 
programs, regardless of their license.

6. This program, including modifications made to it, in addition to its source 
code, may be distributed under any means. This includes, but is not limited, 
electronic mail, compact disks, paper, and magnetic media. Any restriction of 
distribution method, such as restrictions to only one type of distribution, 
are strictly prohibited by this license.

-- 
It's a commonly known fact that most intruders come in through Windows.
