Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYKKHIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYKKHIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYKKHIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:08:06 -0500
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:59403 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYKKHIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:08:06 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2008 02:08:05 EST
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: Possibility to build more kernels in one shot?
Date: Tue, 11 Nov 2008 08:01:14 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811110801.14206.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

currently I compile kernel for 12 different machines. I would like to see 
profile support in kernel, so I could have all my .configs in source and 
compile them in one shot. and than see in profile directory subdirectories 
for every config with it's vmlinuz and modules.

I think it would speedup also compilation time because some .o should be than 
reuse.

Thanks a lot for reply

Michal
