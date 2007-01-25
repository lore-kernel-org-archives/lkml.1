Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXAYNWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXAYNWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965343AbXAYNWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:22:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:30794 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXAYNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hC7j6mt6kfCEeJslLXLv676emV1Sj50bAe90aSx8KxXAWDIFB1+9XYvU5nvDGSEHsHdt6OtWX8ZXiGIEh+ck+N050d9yZ88gCyP63QL+Bl8FoNDh5IZHHdw+63O90gixanQH7DF+jZ58xxdqn/n6kljPGZCmVW6t6xvxTzFfab8=
Message-ID: <b681c62b0701250522r25763481q5f94e2ec8cf2db34@mail.gmail.com>
Date: Thu, 25 Jan 2007 18:52:07 +0530
From: "yogeshwar sonawane" <yogyas@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Sub - Excessive printks increase top mem usage?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I am running a user application which will just open/close my driver
(simple one, empty functions with only printks) infinitely.
A massive use of printk can slow down the system noticeably OR it can
affect some time calculations.
Apart from this, it was increasing top mem usage also. After closing
the application, the memory consumption was not coming down(not
freeing mem). Is this the expected behaviour? OR i am missing
something?

Can anybody help me in guiding the reason for this? Any help/links plz.

Thanks in advance,
Yogeshwar
