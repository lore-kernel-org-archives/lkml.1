Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbYBFD36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbYBFD36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbYBFD3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:29:50 -0500
Received: from smtp.digitalpath.net ([65.164.104.14]:50290 "EHLO
	smtp.digitalpath.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbYBFD3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:29:49 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=digitalpath.net;
  b=id5bKLzMiStro3M3SxCAmZ+na8jt5Z2HpMDI/dJoPHti2PyV+QTUP+jEPYNLYP3Gq+YFmT/PH7IFGYsVcRD6p0IvZkc7hhw64XnDyW9L5Dfjm9xZlNfGb/BSpKir18Ve  ;
Message-ID: <3278.65.164.104.9.1202268587.squirrel@webmail.digitalpath.net>
Date: Tue, 5 Feb 2008 19:29:47 -0800 (PST)
Subject: Access MSR functions in userspace?
From: "Hasan Rashid" <hasan@digitalpath.net>
To: linux-kernel@vger.kernel.org
Reply-To: hasan@digitalpath.net
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a way to use RDMSR and WRMSR in userspace? I only need to write
to one register, writing a module with a userspace piece to handle that
seems like an over kill.

TIA!
-- 
Regards, Hasan R.

