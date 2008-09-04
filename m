Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYIDLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYIDLgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYIDLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 07:36:00 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25433 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754137AbYIDLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 07:35:59 -0400
Message-ID: <48BFC805.9020005@panasas.com>
Date: Thu, 04 Sep 2008 14:35:33 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Massimo Dal Zotto <dz@debian.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: i8k compile error with older compiler
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2008 11:34:41.0818 (UTC) FILETIME=[38CBAFA0:01C90E82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo,

I see the following error with
$ gcc --version
gcc (GCC) 3.4.4 20050721 (Red Hat 3.4.4-2)

  CC [M]  drivers/char/i8k.o
{standard input}: Assembler messages:
{standard input}:315: Error: suffix or operands invalid for `lahf'

The error is not seen with gcc 4.3.0.

Benny
