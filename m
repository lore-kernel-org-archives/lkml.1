Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXCVUhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXCVUhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 16:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934228AbXCVUhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 16:37:01 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:3375 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934222AbXCVUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 16:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nIyrE/0flqzV6i7mpomiq9uLCasScW8WQGBNEd7CxlB6YsMXue6X6KHGxH80ARzDcw+FeHMz2Cz7Sg83frvgUUXiEiWW2JfC24c+YVWBuPF4ANGqT6kmiu17M79GHeuaiSXDp9sTzXmzXWiawgTc4HthgAFnm2l0YY5F/jrB3oc=
Message-ID: <2fe399760703221336w46cc2caby7f3f7706103dab02@mail.gmail.com>
Date: Thu, 22 Mar 2007 13:36:54 -0700
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: issue with 2.6.21-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have an interesting message within my log files for a small file
server running 2.6.21-rc4.  The message is "rpcsvc: received unknown
control message:-2144988692/-1" of which there are quite a few.  I
tried to google around for this but found nothing.  Any help from the
experts?  The machine in question is a dual dual opteron 2.2GHz w/4G
RAM, 3Ware 9650 (14 disk RAID 10), LVM2, XFS file system.  I have
installed and using the latest nfsutils (1.0.12).  I have grabbed some
ethereal and can see nothing unusual.  Any help would be greatly
appreciated!

TIA,
Phy
