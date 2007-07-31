Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbXGaJbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbXGaJbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXGaJbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:31:03 -0400
Received: from main.gmane.org ([80.91.229.2]:44045 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXGaJbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:31:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Whats the problem with my IDE...
Date: Tue, 31 Jul 2007 11:35:52 +0200
Message-ID: <f8mvg9$rc8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e432f1.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 FirefoxSucks/9 SeaMonkey/1.1.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after my problems with my DVD drive, I've unplugged this device and 
jumpered my burning device as master, to start my linux setup from there.

Now I don't longer get those silly DVD errors, but now I get something, 
which is much more worrying for me:

http://pastebin.com/f6fc7552f

After mounting my four LVs, formatted with XFS, here, I'm starting to 
delete all files on those LVs to be able to do a fresh linux install. 
While deleting, I get *many* DMA errors and "BAD CRC" messages.

Maybe someone has a minute of time to tell me who is responsible for 
this errors. Does the kernel not work very well with my IDE controller? 
Is there a defect in the IDE controller? Is there a problem with my HDD?

Thank you *very* much in advance for any information about this...

Yours

Manuel

