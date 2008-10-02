Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbYJBQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbYJBQxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYJBQxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:53:40 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:37849 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbYJBQxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:53:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ZBhGj4PL+AEj5Qna8nyC2e3coCF+JCjS1iJn6APh8fawahYiWy0/o2ciYndmLqb0;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48E4FC91.5010300@earthlink.net>
Date: Thu, 02 Oct 2008 12:53:37 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Automatic config file generator
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79b92127bd9bcd0625af498c874edcb65f350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

Is there a utility that will examine your system and generate a tailored config 
file so I don't have to compile a zillion modules.

Currently when I want to build the latest kernel I take the config file from
my distro, (fedora), but it has every module in the world. So on my
1.8ghz core 2 duo laptop it takes about 30 min to build a new kernel.

Thanks,
Steve
-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


