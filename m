Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXIXJw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXIXJw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXIXJwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:52:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:52747 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXIXJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vsj93B69Mu6Svwd+pfs0x/8rG2ohoqwvlOwZAUCBaZlGBQCQ0xHGnmoc4oPtdSAMu2J6f0fM0LA6OM1fb9ehUAl9aVPOKhowRWSr5UwxuOJySKOfsK77su3ZPp+icrlPMYA1ITnDezcLfpbva9exqc3XP/AvAksawPf6ZShO6wo=
Message-ID: <2cbbd8de0709240252x34d4d66ci6bd2e20e397a7cc1@mail.gmail.com>
Date: Mon, 24 Sep 2007 11:52:03 +0200
From: "Antoine Zen-Ruffinen" <antoine.zen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Compilation problem with kernel 2.6.9
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to compile the kernel 2.6.9 because I want to use it with
RTLinux and that the only 2.6.x kernel supported. I used gcc 2.95.3 as
recommended.
But I have an error by compilation of process.c :

  CC      arch/i386/kernel/process.o
{standard input}: Assembler messages:
{standard input}:777: Error: suffix or operands invalid for `mov'
{standard input}:778: Error: suffix or operands invalid for `mov'
{standard input}:978: Error: suffix or operands invalid for `mov'
{standard input}:979: Error: suffix or operands invalid for `mov'
{standard input}:1051: Error: suffix or operands invalid for `mov'
{standard input}:1052: Error: suffix or operands invalid for `mov'
{standard input}:1161: Error: suffix or operands invalid for `mov'
{standard input}:1162: Error: suffix or operands invalid for `mov'
{standard input}:1172: Error: suffix or operands invalid for `mov'
{standard input}:1184: Error: suffix or operands invalid for `mov'
make[1]: *** [arch/i386/kernel/process.o] Error 1
make: *** [arch/i386/kernel] Error 2

Can someone help me ?
