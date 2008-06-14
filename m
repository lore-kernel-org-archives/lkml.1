Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYFNXMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYFNXMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYFNXLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:11:55 -0400
Received: from caduceus1.gmu.edu ([129.174.0.40]:49352 "EHLO caduceus1.gmu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbYFNXLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:11:54 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2008 19:11:54 EDT
Date: Sat, 14 Jun 2008 18:11:55 -0400
From: Zhaohui Wang <zwange@gmu.edu>
Subject: how to find when a symbol introduced into the kernel
To: linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: zwange@gmu.edu
Message-id: <000b01c8ce6b$a7bfda50$f73f8ef0$@edu>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=UTF-8
Content-language: en-us
Content-transfer-encoding: 7BIT
Thread-index: AcjCRSzJw1zigZ8bR8udDKe1cL80mwMIw7ZgAADN3aA=
x-cr-hashedpuzzle: AXXh EfRK E/YY HVrm JrSF LQ3g LjhR Oj0U SToa TcIK Ul/U VEqn
 aiF/ asej bINJ
 dEcV;3;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG4AZQB3AGIAaQBlAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB6AHcAYQBuAGcAZQBAAGcAbQB1AC4AZQBkAHUA;Sosha1_v1;7;{D717F3E0-93C0-4D9F-8569-FB007D0E31B5};egB3AGEAbgBnAGUAQABnAG0AdQAuAGUAZAB1AA==;Sat,
 14 Jun 2008 22:11:49
 GMT;aABvAHcAIAB0AG8AIABmAGkAbgBkACAAdwBoAGUAbgAgAGEAIABzAHkAbQBiAG8AbAAgAGkAbgB0AHIAbwBkAHUAYwBlAGQAIABpAG4AdABvACAAdABoAGUAIABrAGUAcgBuAGUAbAA=
x-cr-puzzleid: {D717F3E0-93C0-4D9F-8569-FB007D0E31B5}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi all

To write multiple kernel version compatible programs, I need to know when a specific symbol (a struct or a function)were introduced in to the kernel tree

Binary search against multiple kernel sources is a way,but is still slow.Is there any fast way to use modern git technology to make my life easier?

Many thanks.

Best Regards
Zhaohui Wang



