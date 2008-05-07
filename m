Return-Path: <linux-kernel-owner+w=401wt.eu-S1765974AbYEGWIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765974AbYEGWIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbYEGWHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:07:50 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:1745 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYEGWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:07:46 -0400
From: James Cloos <cloos@jhcloos.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Justin Mattock" <justinmattock@gmail.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Regression: starting X locks box with git master
In-Reply-To: <200805072353.02085.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 7 May 2008 23:53:01 +0200")
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	<86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
	<m37iemq3qa.fsf@lugabout.jhcloos.org> <200805072353.02085.rjw@sisk.pl>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2007 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Wed, 07 May 2008 18:06:43 -0400
Message-ID: <m3ej8dbwfp.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:080507:rjw@sisk.pl::wGj7zxdd86NMi9da:000000mywT
X-Hashcash: 1:23:080507:justinmattock@gmail.com::9BRBsqV+quzV58mM:00000000000000000000000000000000000000ZmDf
X-Hashcash: 1:23:080507:yhlu.kernel@gmail.com::TiIynlkZ4+h4UH2F:0000000000000000000000000000000000000000YFKW
X-Hashcash: 1:23:080507:linux-kernel@vger.kernel.org::WtRlXDC8PMJ+64DY:000000000000000000000000000000000CZHs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:

>> But the kernel which dies does generate this:

>> Apr 24 04:28:09 [kernel] [    0.000000] x86: PAT support disabled.

Rafael> Has the problem been fixed in 2.6.26-rc1 or in the current -git?

I plan on giving current master a test tonight.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
