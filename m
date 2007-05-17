Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXEQOpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXEQOpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXEQOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:45:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:60902 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXEQOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MrKgUHYo0UG+xd79WN+BtwTXt6xdQlRZAagBIQcjTsu1cb4NHmJbDg/gBQ71x1uL3nFEVTH2yfYhRYojzlPhVabcB0RcslUATuBiOguXH8MVjX1rBw8W0sGIG1ahmVICkI5QXz1lP8F4Jv3wR9BGT0DeTf2INm9MHu57DwcPBqM=
Message-ID: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
Date: Thu, 17 May 2007 20:15:32 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fork Bombing Attack
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All
              I have set per user process limit ( ulimit) for both
root and guest account as 8000 by using option ulimit -u 8000.this is
Hard limit.  still fork bombing attack killed the box and machine
needed reboot. will any body please tell me why this is so? i have
tried all this attack on machine with FC6 and Linux kernel 2.6.18.

Regards
Anand
