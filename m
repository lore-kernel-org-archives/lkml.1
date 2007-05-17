Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbXEQH0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbXEQH0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbXEQHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:25:57 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:40275 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEQHZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bEl+6vZhgjtXWeqKHJ2Jq+k69FHMn009YzWOMP9IVWkJHT2tmVSLSlYSvg3eV3y6EtWB04resVVBGjb/OZymfQw2axlpO+HoiA1bN0XWO/DQc9CkmMQEqDyju5UfNzgxoMHdBZqJCELDjbVYY+hLQKhvDPeyo566eArhRkhiHFc=
Message-ID: <25ae38200705170025m23fe8ea9s81515ec8d1a0a137@mail.gmail.com>
Date: Thu, 17 May 2007 12:55:53 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fork bombing Attack
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir,
             I just want to know whether fork bombing attack still
exist on the machine having Distribution as Fedora Core 6 and Linux
Kernel 2.6.x.?

           additional Info :  I have set ulimit as 8000 and loged in
as Guest User on machine having Distribution as Fedora Core 6 and
Linux kernel 2.6.18. simple fork bombing program while(1) fork();
killed the box and machine needed reboot. will any body please tell me
why fork bombing attack killed the box even after setting ulimit as
8000?

Regards
Anand
