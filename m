Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYCZCgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYCZCgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYCZCg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:36:27 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:22548 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYCZCg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=d+u/hg0tiSYcpjzax3fpNOouD53ynySfzopAfxmZKQOIfDVIVdpOLHKB3Qmdx5VS+gaPW3/meNvy80yVLZgyvS9eazly5ZTD5ucB6RiwxQ8BiLQ99Fp/9/weQ8PHO9QBDlY367Ap/EuGV9KtSSCAyei2o4c8Kvp7UvwMxASf3RA=
Message-ID: <47E9B6A9.6010408@gmail.com>
Date: Tue, 25 Mar 2008 22:36:25 -0400
From: Fei Liu <feiliu4@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080202 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: A question to Frank Kingswood about ch340/341 support for 2.4.18
 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frank,

 Is there any chance this driver can be back ported to 2.6.18 for 
opensuse 10.2 system? It seems the usb kernel data structures had some 
significant changes from 2.6.18 to 2.6.24. I couldn't hack it to work 
with 2.6.18 after some effort. It'd be really great to be able to use 
this cable on Linux with kernels older than 2.6.24. I can also be 
pointed to the right direction to port this drive back if it does not 
require a significant amount of work (apart from young kid and work).

Fei
