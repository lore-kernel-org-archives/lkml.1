Return-Path: <linux-kernel-owner+w=401wt.eu-S1030687AbXDLS2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687AbXDLS2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDLS2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:28:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19827 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030686AbXDLS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BCdPdr4n4W0UFfxD6gl7ViGAy9rOewWvIe1gVogKQewzK0VM648A0/JmV4YmO+dO+Th5Ohn+WZ3I9v/YpSKeISCF9N2Ea9mVcyBReFi3Fq+uJoVPFi60/tBjOKJc84/2Wb3QotTld3alYchLLDXah0TQxurC4pQVJq7RRme8jKE=
Message-ID: <c43b2e150704121128h3a93cf05icb2d70f1fb6e42d3@mail.gmail.com>
Date: Thu, 12 Apr 2007 20:28:00 +0200
From: wixor <wixorpeek@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: VM stats of dead child
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I need to get peek memory usage of dead child process - how can I
accomplish this if getrusage doesn't return memory statistics (why?)
and /proc seems to not contain them either? Thanks in advance.

-
wixor
