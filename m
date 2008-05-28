Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbYE1NzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbYE1NzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYE1NzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:55:13 -0400
Received: from fig.raritan.com ([12.144.63.197]:41971 "EHLO fig.raritan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYE1NzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:55:12 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 09:55:12 EDT
Message-ID: <483D609B.3020509@raritan.com>
Date: Wed, 28 May 2008 15:39:39 +0200
From: Ronald Wahl <ronald.wahl@raritan.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Q: Is the "x86: clear DF before calling signal handler" issue affecting
 User Mode Linux, too?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2008 13:39:40.0944 (UTC) FILETIME=[47BA4100:01C8C0C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just have a short question to the recent issue with gcc 4.3.x which 
was fixed here:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e40cd10ccff3d9fbffd57b93780bee4b7b9bff51

Does User Mode Linux on x86 need a similar fix?

Thanks,
ron

-- 
Ronald Wahl - ronald.wahl@raritan.com
Raritan Deutschland GmbH, Kornmarkt 7, 08056 Zwickau
Phone +49 375271349-0 Fax -99, USt-IdNr. DE813094160, HRB 23605 Chemnitz
Geschäftsführer / Managing Director: Gerard W. J. Heuvel
